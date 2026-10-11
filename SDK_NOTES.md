# SDK decision — 2026-10-07

NexaCart deliberately separates **compile SDK** from **target SDK**:

- Flutter stable: **3.47.x**
- Dart: **3.13.2+**
- Android `compileSdk`: **37** (Android 17 SDK, current API surface)
- Android `targetSdk`: **36** (Android 16, current Google Play submission baseline)
- Android `minSdk`: **24**
- Java/JVM: **17**
- Gradle wrapper: **9.3.1**
- Android Gradle Plugin: **9.1.0**
- Kotlin plugin declaration: **2.4.0**
- iOS deployment target: **15.0**

Why not `targetSdk = 37` by default? Android 17 is currently presented by Android Developers as the current SDK/preview surface. `compileSdk = 37` lets the project compile against the newest API while `targetSdk = 36` keeps runtime behavior aligned with the current stable Google Play requirement. The app still runs on Android 17 devices.

## Realm 20.2.0 compatibility

Realm 20.2.0 still ships an Android Gradle declaration using `compileSdk 31`. On modern Flutter/AndroidX this produces AAR metadata errors. The included setup scripts patch the local Pub cache declaration to API 37 after `flutter pub get` and before analysis/build.

Windows:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\tool\setup_windows.ps1
flutter run
```

macOS/Linux:

```bash
chmod +x tool/setup_unix.sh
./tool/setup_unix.sh
flutter run
```

If you later clear/repair the Pub cache or change Realm version, rerun the setup script.
