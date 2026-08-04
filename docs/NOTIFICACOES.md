# Notificações push — plano de implementação

Status: **proposta, aguardando decisões**. Nada implementado ainda.

Requisito definido: o usuário precisa receber a notificação **com o app fechado**.
Isso elimina a opção "só in-app" e torna push obrigatório.

---

## 1. Situação atual

O que já existe no app é apenas casca:

| Item | Onde | Estado |
|---|---|---|
| `NotificationService` | `lib/modules/core/domain/services/notification_service.dart` | Stub — tem um `hasNotification` que nunca é setado |
| Botão de sino com badge | `.../icon_buttons/notification_icon_button_widget.dart` | Renderiza, mas o badge nunca acende |
| Registro do service | `.../bindings/application_bindings.dart:11` | OK |

Não existe: dependência de push no `pubspec.yaml`, `google-services.json`, configuração
de APNs no iOS, tabela de notificações, nem endpoint no backend.

Infra que já existe e será reaproveitada:

- **Supabase** (projeto `Redde.ai`, ref `glvskgxbkdmgrzrvsscw`) — é onde vivem `Usuarios`,
  `Empresa`, `EmpresaFilial`, `UsuarioTipo`. Já usado pelo app para storage de fotos.
- **Backend `posto360.app`** — API REST em `/api/mobile/*`, autenticada por JWT. Não está
  neste repositório.
- **Identificadores do app**: `br.com.redepedrabranca.posto360` (mesmo applicationId no
  Android e bundle id no iOS — simplifica o setup do Firebase).

---

## 2. Arquitetura proposta

```
evento de domínio (chamado criado, checklist vencendo, ...)
        │
        ▼
  backend posto360.app  ──escreve──►  Supabase: Notificacoes
        │
        └──lê tokens──►  Supabase: DispositivoTokens
                 │
                 ▼
         FCM HTTP v1 API
            ├──► Android (FCM)
            └──► iOS (APNs via FCM)
                     │
                     ▼
                   app
```

**Por que FCM nas duas plataformas:** o `firebase_messaging` entrega Android e iOS com uma
API só; no iOS o Firebase repassa para o APNs. A alternativa (falar com APNs direto) exigiria
duas integrações no backend.

**Onde disparar o envio:** no backend `posto360.app`, junto do código que já processa o evento
(ex.: no mesmo handler que cria o chamado). Alternativa: Supabase Edge Function acionada por
trigger na tabela — vale se os eventos nascerem de escrita direta no banco, sem passar pela API.

> Atenção: a API legada do FCM (server key) foi desativada. O envio precisa usar a **HTTP v1
> API**, que autentica com uma **service account JSON** e token OAuth2. Isso muda o código do
> backend em relação a tutoriais antigos.

---

## 3. Pré-requisitos que dependem de vocês

Nada disso eu consigo fazer pelo código — são acessos e consoles externos:

1. **Projeto no Firebase** com os apps Android e iOS registrados sob
   `br.com.redepedrabranca.posto360`. Gera o `google-services.json` (Android) e o
   `GoogleService-Info.plist` (iOS).
2. **Chave de autenticação APNs (`.p8`)** gerada no Apple Developer, com o Key ID e o Team ID,
   subida no Firebase. Exige a conta Apple Developer paga — vocês já têm, pelas publicações.
3. **Capability "Push Notifications"** habilitada no App ID e no target Runner do Xcode.
4. **Service account JSON** do Firebase, guardada como secret no backend, para o envio.

Sem os itens 1–3, push no iOS não funciona nem em desenvolvimento. Push **não funciona no
simulador iOS** — os testes de iOS precisam de aparelho físico.

---

## 4. Modelagem de dados

Duas tabelas novas no Supabase. Nomes seguem o padrão PascalCase já usado no schema.

### `DispositivoTokens`

Um usuário pode ter vários aparelhos; um aparelho pode trocar de usuário.

| Coluna | Tipo | Nota |
|---|---|---|
| `id` | uuid PK | |
| `usuarioId` | uuid FK → `Usuarios.id` | |
| `token` | text **unique** | token do FCM |
| `plataforma` | text | `android` / `ios` |
| `appVersion` | text | ajuda a depurar entregas |
| `criadoEm` / `atualizadoEm` | timestamptz | |

Regras: `upsert` pelo `token` no login e no `onTokenRefresh`; **delete no logout** (senão o
próximo usuário do aparelho recebe notificação do anterior); limpeza dos tokens que o FCM
devolver como inválidos (`UNREGISTERED`) no envio.

### `Notificacoes`

Guardar o histórico é o que permite ter a lista in-app e o badge do sino — e é essencial para
depurar "não chegou".

| Coluna | Tipo | Nota |
|---|---|---|
| `id` | uuid PK | |
| `usuarioId` | uuid FK → `Usuarios.id` | destinatário resolvido |
| `empresaId` / `filialId` | int | filtro e auditoria |
| `tipo` | text | `chamado_novo`, `checklist_vencendo`, ... |
| `titulo` / `corpo` | text | o que aparece na notificação |
| `rota` | text | destino do toque, ex.: `/chamados/123` |
| `dadosJson` | jsonb | payload extra |
| `lidaEm` | timestamptz null | null = não lida → badge |
| `criadoEm` | timestamptz | |

Índice em `(usuarioId, lidaEm, criadoEm desc)`.

**RLS é obrigatório nas duas tabelas** — o app carrega a anon key, então sem policy qualquer
usuário lê as notificações de todos.

---

## 5. Contrato dos endpoints

No padrão `/api/mobile/*` já usado, autenticado pelo mesmo JWT:

| Rota | Método | Body | Resposta |
|---|---|---|---|
| `/api/mobile/notificacoes/registrar-token` | POST | `{ token, plataforma, appVersion }` | `200` |
| `/api/mobile/notificacoes/remover-token` | POST | `{ token }` | `200` |
| `/api/mobile/notificacoes` | POST | `{ usuarioId, apenasNaoLidas? }` | lista de notificações |
| `/api/mobile/notificacoes/marcar-lida` | POST | `{ notificacaoId }` ou `{ todas: true }` | `200` |

### Payload que o backend manda pro FCM

O bloco `data` é o que o app usa pra navegar no toque. Manter as chaves como **string** — o FCM
rejeita outros tipos em `data`.

```json
{
  "message": {
    "token": "<token do aparelho>",
    "notification": { "title": "Novo chamado", "body": "Troca de bico — Filial Centro" },
    "data": { "tipo": "chamado_novo", "rota": "/chamados/123", "notificacaoId": "<uuid>" },
    "android": { "priority": "high", "notification": { "channel_id": "posto360_geral" } },
    "apns": { "payload": { "aps": { "sound": "default", "badge": 1 } } }
  }
}
```

O `channel_id` precisa bater com o canal criado no app, senão o Android não mostra heads-up.

---

## 6. Mudanças no app

### Dependências

```yaml
firebase_core: ^3.x
firebase_messaging: ^15.x
flutter_local_notifications: ^18.x   # exibir notificação com o app em primeiro plano
```

### Arquivos a criar/alterar

| Arquivo | O quê |
|---|---|
| `lib/main.dart` | `Firebase.initializeApp()` antes do `runApp`; registrar o handler de background |
| `.../services/notification_service.dart` | Deixar de ser stub: permissão, token, streams, contador de não lidas |
| `lib/modules/notificacoes/**` | Módulo novo: lista, controller, binding, repository, service (mesmo padrão de `chamados`) |
| `.../routers/` | Rota `/notificacoes` |
| `dash_page.dart` / `dash_gerente_page.dart` | Ligar o sino ao contador real e navegar pra lista |
| `auth_service.dart` | Registrar token no login; **remover no logout** |

### Pontos de atenção do Flutter

- O handler de background **tem que ser função top-level** anotada com
  `@pragma('vm:entry-point')` — dentro de classe não funciona em release.
- Três estados a tratar, e são caminhos de código diferentes:
  `onMessage` (app aberto), `onMessageOpenedApp` (background, usuário tocou) e
  `getInitialMessage()` (app estava **fechado** — é o caso do requisito).
- Com o app em primeiro plano o Android **não** mostra a notificação sozinho: é o
  `flutter_local_notifications` que exibe, e o canal precisa ser criado na inicialização.
- **Android 13+** exige permissão `POST_NOTIFICATIONS` em runtime. Pedir num momento com
  contexto (não no primeiro frame do app) melhora muito a taxa de aceite.
- Navegação no toque: o app usa GetX, então o `data.rota` mapeia direto pra `Get.toNamed`.
  Só que no caso do app fechado a rota chega **antes** do login estar resolvido — precisa
  enfileirar o destino e navegar depois que o `AuthService` terminar, senão cai no `/login`
  e a notificação "não faz nada".

### Configuração nativa

**Android**: `google-services.json` em `android/app/`, plugin `com.google.gms.google-services`
no Gradle, permissão `POST_NOTIFICATIONS` no manifest, canal default declarado em meta-data.

**iOS**: `GoogleService-Info.plist` no target Runner, capability Push Notifications,
Background Modes → Remote notifications, `UNUserNotificationCenter` delegate,
e o `aps-environment` no entitlements (`development` / `production`).

---

## 7. Eventos que disparam notificação — **a definir**

Esta é a decisão que falta e ela guia todo o resto. Proposta inicial para vocês editarem:

| Evento | Quem recebe | Rota |
|---|---|---|
| Chamado novo designado à filial | Gerente da filial | `/chamados/:id` |
| Chamado respondido/finalizado pelo escritório | Quem abriu | `/chamados/:id` |
| Checklist pendente perto do vencimento | Responsável | `/checklists` |
| Avaliação recebida | Avaliado | `/avaliacoes` |
| Curso ou aula nova disponível | Vendedores da empresa | `/cursos` |
| Campanha nova | Vendedores participantes | `/campanhas` |

Para cada linha é preciso definir o público exato (tipo de usuário + filial/empresa) e o
gatilho no backend.

---

## 8. Ordem de execução sugerida

1. **Vocês**: criar projeto Firebase, registrar os dois apps, subir a chave APNs.
2. **Backend**: criar as duas tabelas com RLS e os quatro endpoints.
3. **App**: integrar `firebase_core` + `firebase_messaging`, registrar token no login,
   receber e exibir notificação. Testar com envio manual pelo console do Firebase.
4. **Backend**: disparar no primeiro evento real (sugiro chamado novo — é o de dono mais claro).
5. **App**: tela de lista, badge do sino, marcar como lida, navegação por `rota`.
6. Ampliar para os demais eventos.

O passo 3 já dá pra validar ponta a ponta com o app fechado, antes de existir qualquer evento
de domínio.

---

## 9. Riscos

- **iOS é onde push costuma falhar**: chave APNs errada, entitlement de `development` num build
  de produção ou capability faltando resultam em "não chega" silencioso, sem erro no app.
  Reservar tempo de teste em aparelho físico.
- **Token órfão no logout**: se não apagar, o próximo usuário do aparelho recebe notificação
  alheia — vazamento de informação entre funcionários, não só bug.
- **Sem RLS, a anon key expõe as notificações de todos os 344 usuários.**
- Quem for escrever o envio no backend precisa usar a **HTTP v1 API**; a maioria dos tutoriais
  ainda ensina a API legada, que foi desativada.
