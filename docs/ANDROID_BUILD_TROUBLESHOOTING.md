# Android build troubleshooting

## `No such host is known (dl.google.com)`
This is not the NexaCart application ID, Firebase domain, or Facebook domain.
Gradle is trying to download official Android build artifacts from Google Maven (`dl.google.com`).

Run in Administrator PowerShell:

```powershell
Resolve-DnsName dl.google.com
ipconfig /flushdns
netsh winsock reset
```

Restart Windows after `netsh winsock reset`.
If DNS is still failing, use a public DNS resolver such as Google DNS (8.8.8.8 / 8.8.4.4) or Cloudflare DNS (1.1.1.1 / 1.0.0.1), then test:

```powershell
Resolve-DnsName dl.google.com
Test-NetConnection dl.google.com -Port 443
```

Do not change `applicationId` to fix this error; it is unrelated.

## Kotlin / AGP
NexaCart v1.2 enables AGP built-in Kotlin because current Flutter supports it and `flutter_facebook_auth >=7.1.8` migrated its Android plugin to built-in Kotlin.

`android/gradle.properties`:

```properties
android.newDsl=false
android.builtInKotlin=true
```

The old `org.jetbrains.kotlin.android` plugin declaration was removed from `android/settings.gradle.kts`.

## Facebook configuration
The plugin stays in the project because Facebook sign-in is a real requested feature. A real Meta/Firebase configuration is still required at runtime. Build-time access to Google Maven is required to download Android tooling/dependencies.


## Flutter 3.47 / AGP 9 / Built-in Kotlin

AGP 9.1.x ships a runtime dependency on KGP 2.2.10. Flutter 3.47 validates a minimum KGP of 2.2.20, while `flutter_facebook_auth` 7.1.8+ is migrated to AGP Built-in Kotlin. NexaCart therefore keeps `android.builtInKotlin=true` and overrides the top-level Kotlin Gradle Plugin runtime to **2.4.20** in `android/build.gradle.kts`. Kotlin 2.4.20 is compatible with Gradle 9.3.1 and AGP 9.1.x.

Do not re-add `org.jetbrains.kotlin.android` to the app while Built-in Kotlin is enabled.
