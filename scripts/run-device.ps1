# Sobe o app no celular Android conectado.
#
#   .\scripts\run-device.ps1              -> usa o primeiro device Android
#   .\scripts\run-device.ps1 RQGL209JN2A  -> usa um device especifico
#
# Depois que subir, no proprio terminal:  r = hot reload | R = hot restart | q = sair

param([string]$DeviceId)

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)

# adb costuma nao estar no PATH no Windows
$adb = 'adb'
$sdkAdb = Join-Path $env:LOCALAPPDATA 'Android\Sdk\platform-tools\adb.exe'
if (Test-Path $sdkAdb) { $adb = $sdkAdb }

if (-not $DeviceId) {
    $linha = & $adb devices | Select-String '\sdevice$' | Select-Object -First 1
    if (-not $linha) {
        Write-Host "Nenhum celular conectado. Confere o cabo USB e a depuracao USB." -ForegroundColor Red
        Write-Host "Se aparecer 'unauthorized', aceita o popup na tela do aparelho." -ForegroundColor Yellow
        exit 1
    }
    $DeviceId = ($linha -split '\s+')[0]
}

Write-Host "Device: $DeviceId" -ForegroundColor Cyan

& flutter run -d $DeviceId
if ($LASTEXITCODE -eq 0) { exit 0 }

# O adb do Flutter as vezes falha o install (USB reconectando).
# Instala na mao e tenta de novo - o build ja esta em cache, entao e rapido.
Write-Host "`nInstall falhou. Instalando o APK direto pelo adb..." -ForegroundColor Yellow

$apk = 'build\app\outputs\flutter-apk\app-debug.apk'
if (-not (Test-Path $apk)) {
    Write-Host "APK nao encontrado em $apk - o build nao chegou a terminar." -ForegroundColor Red
    exit 1
}

& $adb -s $DeviceId install -r $apk
if ($LASTEXITCODE -ne 0) {
    Write-Host "adb install falhou. Se falar em assinatura, desinstala o app do aparelho e roda de novo." -ForegroundColor Red
    exit 1
}

& flutter run -d $DeviceId
exit $LASTEXITCODE
