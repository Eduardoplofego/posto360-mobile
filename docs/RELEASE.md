# Release — Posto360 (Play Store)

Procedimento para gerar e publicar uma nova versão do app Android na Google Play Console.

## Pré-requisitos

- Flutter instalado e funcionando (`flutter doctor`)
- Android Studio (traz o JDK em `C:\Program Files\Android\Android Studio\jbr\`)
- Acesso à Google Play Console do app `br.com.redepedrabranca.posto360`
- Keystore de upload (ver seção [Keystore](#keystore))

## Versionamento

A versão é definida em `pubspec.yaml` no formato `versionName+versionCode`:

```yaml
version: 1.2.0+7
```

- `versionName` (`1.2.0`) — visível ao usuário, formato semântico
- `versionCode` (`7`) — inteiro **estritamente crescente**, exigido pela Play Console (cada novo upload deve ter um número maior que o anterior)

A cada release: bump de pelo menos o `versionCode`. Bump do `versionName` segue convenção semver:
- `MAJOR` — breaking changes
- `MINOR` — features novas (ex: 1.1.x → 1.2.0 com módulo novo)
- `PATCH` — bugfix

## Keystore

A assinatura do AAB depende de um keystore (`.jks`) que **não está no repositório** (e nunca deve ser commitado).

### Localização

| Item | Valor |
|------|-------|
| Caminho local | `C:\Users\dudup\keystores\upload-keystore.jks` |
| Alias | `upload` |
| Owner | `CN=Luiz Falqueto` |
| Validade | 20/10/2025 → 07/03/2053 |
| SHA-1 | `A4:51:E6:39:7A:11:B5:03:A8:FE:E7:F4:BF:E5:A0:1D:20:36:C6:29` |
| SHA-256 | `84:97:62:EB:72:DF:83:18:D1:2B:8B:60:F3:8C:31:E7:3F:27:01:E5:92:20:AF:68:E0:A6:E0:E2:7D:30:90:6B` |

O SHA-1 acima deve sempre bater com o SHA-1 mostrado em **Play Console → Testar e lançar → Configuração → Integridade do app → Assinatura de apps → Certificado da chave de upload**.

### Backup

O `.jks` é **insubstituível**. Manter pelo menos 2 cópias além da local:

1. Drive criptografado (Google Drive em pasta privada / OneDrive)
2. Gerenciador de senhas (1Password / Bitwarden — permitem anexar arquivos)
3. Idealmente também offline (pendrive guardado fisicamente)

As **senhas** (storePassword e keyPassword) ficam no mesmo gerenciador de senhas, **nunca em arquivo no repositório**.

### Estrutura do `key.properties`

Arquivo `android/key.properties` (no `.gitignore`, não commitar):

```properties
storePassword=<senha do keystore>
keyPassword=<senha da chave>
keyAlias=upload
storeFile=C:/Users/dudup/keystores/upload-keystore.jks
```

O Gradle lê esses valores em `android/app/build.gradle.kts` e usa pra assinar o build de release.

### Inspecionar o keystore

```
"C:/Program Files/Android/Android Studio/jbr/bin/keytool.exe" -list -v -keystore "C:/Users/dudup/keystores/upload-keystore.jks"
```

(Vai pedir a senha interativamente — preferível a passar `-storepass` na linha de comando, que registra a senha no histórico do shell.)

## Procedimento de release

### 1. Bump de versão

Edita `pubspec.yaml` linha `version:` — incrementa pelo menos o `versionCode`.

### 2. Verificar código

```
flutter analyze
```

Não pode haver issues. Se houver, resolve antes de continuar.

### 3. Limpar e reinstalar dependências

```
flutter clean
flutter pub get
```

### 4. Gerar AAB assinado

```
flutter build appbundle --release
```

Saída: `build/app/outputs/bundle/release/app-release.aab`

### 5. Commit do bump

```
git add pubspec.yaml
git commit -m "build: version <versionName> <versionCode>"
```

### 6. Upload na Play Console

1. **Play Console → Testar e lançar → Produção** (ou trilha de teste, se for o caso: Teste interno / Teste fechado / Teste aberto)
2. **Criar nova versão**
3. Em **App bundles**: arrastar/upload do `app-release.aab`
4. **Detalhes da versão**:
   - **Nome da versão**: igual ao `versionName` (`1.2.0`)
   - **Notas da versão (PT-BR)**: cola o changelog (max 500 chars por idioma)
5. **Avançar** → revisar → **Iniciar lançamento na produção**

### 7. Tag git (recomendado, opcional)

Depois do upload bem-sucedido:

```
git tag v1.2.0
git push --tags
```

## Recuperação em caso de perda do keystore

Se o `.jks` for perdido (todas as cópias) e a Play Console **tem Play App Signing ativo** (que é o caso deste app):

1. Gerar keystore novo:

```
"C:/Program Files/Android/Android Studio/jbr/bin/keytool.exe" -genkey -v -keystore C:/Users/dudup/keystores/upload-keystore-new.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Exportar certificado público:

```
"C:/Program Files/Android/Android Studio/jbr/bin/keytool.exe" -export -rfc -keystore C:/Users/dudup/keystores/upload-keystore-new.jks -alias upload -file upload_certificate.pem
```

3. **Play Console → Integridade do app → Solicitar redefinição da chave de upload**, anexar o `.pem`
4. Aguardar aprovação do Google (até 48h, geralmente menos)
5. Quando aprovado: atualizar `key.properties` apontando para o novo `.jks` e seguir release normal

Usuários **não percebem nada** — o Google continua re-assinando o app instalado com a chave de assinatura do app (que ele guarda).

## Troubleshooting

- **`Your Android App Bundle was signed with the wrong key`**: SHA-1 do keystore não bate com o registrado na Play Console. Conferir com `keytool -list -v` e comparar com o certificado da chave de upload na Console.
- **`Version code X has already been used`**: o `versionCode` no `pubspec.yaml` precisa ser maior que qualquer um já enviado (mesmo de tracks de teste).
- **Build falha em `flutter build appbundle`**: rodar `flutter clean && flutter pub get` antes; conferir `flutter doctor`.
