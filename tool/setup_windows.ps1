$ErrorActionPreference = "Stop"

function Invoke-NativeChecked {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][scriptblock]$Command
    )

    & $Command
    if ($LASTEXITCODE -ne 0) {
        throw "$Name failed with exit code $LASTEXITCODE"
    }
}

Write-Host "NexaCart v1.3 setup" -ForegroundColor Cyan
Write-Host "1/8 Checking Flutter..." -ForegroundColor Cyan
Invoke-NativeChecked "flutter --version" { flutter --version }
Invoke-NativeChecked "flutter doctor" { flutter doctor }

Write-Host "2/8 Checking access to Google Maven..." -ForegroundColor Cyan
try {
    Resolve-DnsName dl.google.com -ErrorAction Stop | Out-Null
    Write-Host "DNS OK: dl.google.com" -ForegroundColor Green
} catch {
    Write-Host "DNS FAILED for dl.google.com." -ForegroundColor Red
    Write-Host "Run in Administrator PowerShell: ipconfig /flushdns ; netsh winsock reset" -ForegroundColor Yellow
    Write-Host "Then restart Windows. If necessary use DNS 8.8.8.8/8.8.4.4 or 1.1.1.1/1.0.0.1." -ForegroundColor Yellow
    throw "Cannot resolve dl.google.com"
}

try {
    Invoke-WebRequest -Uri "https://dl.google.com/dl/android/maven2/com/android/tools/build/gradle/maven-metadata.xml" -Method Head -TimeoutSec 20 -UseBasicParsing | Out-Null
    Write-Host "Google Maven reachable." -ForegroundColor Green
} catch {
    Write-Host "Google Maven HTTPS is blocked/unavailable. Check proxy/VPN/firewall/ISP." -ForegroundColor Red
    throw
}

Write-Host "3/8 Resolving Dart/Flutter packages..." -ForegroundColor Cyan
Invoke-NativeChecked "flutter pub get" { flutter pub get }

Write-Host "4/8 Applying Realm Android compileSdk compatibility patch..." -ForegroundColor Cyan
$pubCache = if ($env:PUB_CACHE) { $env:PUB_CACHE } else { Join-Path $env:LOCALAPPDATA "Pub\Cache" }
$realmGradle = Join-Path $pubCache "hosted\pub.dev\realm-20.2.0\android\build.gradle"
if (-not (Test-Path $realmGradle)) { throw "Realm 20.2.0 build.gradle was not found at $realmGradle" }
$content = Get-Content $realmGradle -Raw
$content = $content -replace 'compileSdkVersion\s*[= ]\s*31', 'compileSdkVersion 37'
$content = $content -replace 'compileSdk\s*=\s*31', 'compileSdk = 37'
$content = $content -replace 'compileSdk\s+31', 'compileSdk 37'
Set-Content -Path $realmGradle -Value $content -Encoding UTF8
Invoke-NativeChecked "realm install" { dart run realm install }

Write-Host "5/8 Generating launcher icons..." -ForegroundColor Cyan
Invoke-NativeChecked "flutter_launcher_icons" { dart run flutter_launcher_icons }

Write-Host "6/8 Generating native splash..." -ForegroundColor Cyan
Invoke-NativeChecked "flutter_native_splash" { dart run flutter_native_splash:create }

Write-Host "7/8 Cleaning and analyzing..." -ForegroundColor Cyan
Invoke-NativeChecked "flutter clean" { flutter clean }
Invoke-NativeChecked "flutter pub get (after clean)" { flutter pub get }
Invoke-NativeChecked "flutter analyze" { flutter analyze }

Write-Host "8/8 Android build smoke test..." -ForegroundColor Cyan
Invoke-NativeChecked "flutter build apk --debug" { flutter build apk --debug }

Write-Host "Setup and debug APK build completed successfully." -ForegroundColor Green
Write-Host "Now run: flutter run" -ForegroundColor Green
