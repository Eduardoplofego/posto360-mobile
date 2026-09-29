---
name: notificacoes-push
description: Guia de notificações push (FCM/APNs) do app Posto 360 — arquitetura decidida, pré-requisitos externos, ordem de implementação e as armadilhas que fazem push falhar em silêncio. Use ao implementar ou depurar notificação, push, FCM, firebase_messaging, APNs, device token, badge do sino, ou a tela de notificações neste projeto.
---

# Notificações push — Posto 360

Plano completo e modelagem detalhada: [docs/NOTIFICACOES.md](../../../docs/NOTIFICACOES.md).
Este arquivo é o resumo operacional. **Confirme o estado atual do código antes de agir** — o
que segue foi levantado em 30/07/2026 e pode ter avançado.

## Requisito que define tudo

O usuário precisa receber **com o app fechado**. Isso elimina qualquer solução só in-app e
torna push obrigatório. Ao avaliar alternativas, essa é a restrição que manda.

## Fatos do projeto (verificados)

- `applicationId` Android e bundle id iOS são **o mesmo**: `br.com.redepedrabranca.posto360`.
- O Supabase conectado **é o banco do Posto 360** (`Usuarios` ~344 linhas, `Empresa`,
  `EmpresaFilial`, `UsuarioTipo`). Tabelas novas vão lá, com FK para `Usuarios.id` (uuid).
- Credenciais do Supabase vêm de `--dart-define` (`SUPABASE_BACKEND_URL`, `ANON_KEY`) via
  `EnvironmentsVariables` — não estão versionadas.
- Backend `posto360.app`, API `/api/mobile/*` com JWT. **Não está neste repositório** — só dá
  para fazer o lado do app.
- Já existe como casca: `NotificationService` (stub, `hasNotification` nunca setado),
  `NotificationIconButtonWidget` (badge nunca acende), registro em `ApplicationBindings`.
- Não existe: dependência de push no `pubspec.yaml`, `google-services.json`, config de APNs.

## Arquitetura decidida

Evento no backend → grava em `Notificacoes` → lê `DispositivoTokens` → **FCM HTTP v1** →
Android direto, iOS via APNs. FCM nas duas plataformas para ter uma integração só no backend.

## Pré-requisitos externos (bloqueiam o iOS)

Projeto Firebase com os dois apps registrados, chave APNs `.p8` subida no Firebase, capability
Push Notifications no App ID e no target Runner, service account JSON no backend.
**Push não funciona no simulador iOS** — teste em aparelho físico.

## Armadilhas

Estas são as que custam mais tempo. Todas falham em silêncio.

- **API legada do FCM foi desativada.** O envio precisa usar a HTTP v1 API (service account +
  OAuth2). A maioria dos tutoriais ainda ensina a antiga com server key.
- **Handler de background tem que ser função top-level** com `@pragma('vm:entry-point')`.
  Dentro de classe funciona em debug e quebra em release.
- **App fechado é um caminho de código próprio**: `getInitialMessage()`, não `onMessage` nem
  `onMessageOpenedApp`. É justamente o caso do requisito, e é o que mais escapa em teste.
- **Navegação no toque com app fechado corre antes do login resolver.** O app usa GetX e o
  `AuthService` redireciona por `ever(_isLogged)`. Se navegar direto pela `rota` do payload,
  cai no `/login` e a notificação parece não fazer nada. Enfileirar o destino e navegar depois
  que a autenticação estabilizar.
- **Em primeiro plano o Android não exibe nada sozinho** — precisa de
  `flutter_local_notifications` e o canal criado na inicialização, com `channel_id` batendo
  com o que o backend manda.
- **Android 13+ exige `POST_NOTIFICATIONS` em runtime.** Pedir em momento com contexto, não
  no primeiro frame.
- **Token órfão no logout** = o próximo usuário do aparelho recebe notificação do anterior.
  É vazamento entre funcionários, não só bug. `AuthService.logout()` tem que apagar o token.
- **RLS obrigatório** em `DispositivoTokens` e `Notificacoes`: o app carrega a anon key, então
  sem policy qualquer usuário lê as notificações de todos.
- **`data` do FCM só aceita string.** Outros tipos são rejeitados no envio.

## Ordem de implementação

1. (Externo) Firebase + chave APNs.
2. (Backend) Tabelas com RLS + endpoints: registrar-token, remover-token, listar, marcar-lida.
3. (App) `firebase_core` + `firebase_messaging`, registro de token no login, recebimento.
   Validar ponta a ponta com envio manual pelo console do Firebase — não depende de evento real.
4. (Backend) Primeiro evento real. Sugerido: chamado novo (dono mais claro).
5. (App) Tela de lista, badge real no sino, marcar como lida, navegação por `rota`.
6. Demais eventos.

## Ainda em aberto

- **Lista definitiva de eventos e público de cada um** — proposta na seção 7 do plano,
  não confirmada. É o que guia a modelagem; não modelar sem isso fechado.
- Quem escreve o backend.

## Convenções do app a seguir

Módulo novo em `lib/modules/notificacoes/` no mesmo padrão de `lib/modules/chamados/`:
`domain/` (models, repositories) · `infra/` (repositories, services) · `services/` (impl) ·
`widgets/`, com `*_bindings.dart` / `*_controller.dart` / `*_page.dart` na raiz e rota
registrada em `*_routers.dart`.

Rotas de API centralizadas em `lib/modules/core/domain/rest_client/api_routes/api_routes.dart`.

**Nunca use `Get.back()` dentro de `showModalBottomSheet`** — o GetX tenta fechar snackbar
antes de navegar e estoura `LateInitializationError`, deixando a aba presa. Use
`Navigator.of(sheetContext).pop(...)`.
