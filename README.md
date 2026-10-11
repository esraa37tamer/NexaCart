# NexaCart — Graduation E-Commerce App

A complete Flutter graduation-project implementation based on the supplied client brief and architecture lesson.

## Implemented

- Email/password authentication abstraction with Firebase Auth implementation and a demo fallback so the app can launch before Firebase credentials are added.
- Realm-backed signed-in session persistence.
- DummyJSON products through Dio + Repository.
- Material 3 `SearchBar`, API search, categories, and `GridView.builder`.
- Product details using Navigator 2.0 route definitions.
- Cart managed entirely with Cubit: add/remove/increase/decrease/total/checkout.
- Realm cart persistence.
- Checkout success dialog and local Realm order history.
- Dedicated async Cubits with explicit loading/success/failure states for Products and Orders.
- Feature-first Data / Domain / Presentation architecture.
- SOLID/DRY-oriented repository contracts, use cases, data sources and reusable widgets.
- Custom Navigator 2.0 `RouterDelegate` + `RouteInformationParser` and centralized route names.
- NexaCart app icon, animated GIF Flutter splash, and generated UI design references.

## Architecture

```text
Presentation (Screens / Widgets / Cubits)
                 |
                 v
           Domain Use Cases
                 |
                 v
       Repository Interfaces
                 ^
                 |
Data Repository Implementations
                 |
                 v
       Data Sources / Realm / API
```

The dependency direction is:

```text
Presentation -> Domain <- Data
```

Domain code does not import Flutter widgets, Dio, Firebase, or Realm.

## SDK baseline — October 2026

- Flutter: 3.47 stable
- Dart: 3.13.x
- Android `compileSdk`: 37
- Android `targetSdk`: 36
- Android `minSdk`: 23
- Java: 17
- iOS deployment target: 15.0

The iOS deployment target is the minimum supported OS, not a maximum; current iPhones are supported when building with a current Xcode/Flutter toolchain.

## First run on Windows

Open PowerShell in the project root:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\tool\setup_windows.ps1
flutter run
```

The setup script applies the Realm 20.2.0 Android `compileSdk 31 -> 37` compatibility patch in the local Pub cache before validation.

## Firebase Auth setup

The production `FirebaseAuthRemoteDataSource` is already included. Until a Firebase project is attached, dependency injection falls back to the demo auth data source so the app remains runnable.

To enable real Firebase:

1. Create/select a Firebase project.
2. Run `flutterfire configure`.
3. Add the generated platform configuration.
4. Enable Authentication > Email/Password in Firebase Console.
5. On the next run, `Firebase.initializeApp()` succeeds and the Firebase data source is selected automatically.

No Firebase credentials are bundled in this ZIP.

## Realm note

The Realm generated model source is committed. If you change Realm model fields:

```bash
dart run realm generate
```

Then rerun the setup script so the Android API 37 patch remains applied.

## Validation commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## Design assets

- Runtime assets: `assets/images/`
- Generated visual references: `assets/design_reference/`
- The application UI is real Flutter widget code. The screenshots are references, not screen-sized UI images.


## v1.1 logic fixes
- Real Remember Me semantics backed by Realm.
- Email/password registration now creates the account then returns to Sign In.
- Google and Facebook Firebase authentication paths added.
- Dark mode button now changes and persists the real app theme.
- Favorites heart is functional, animated, persisted per user, and has a Favorites page.
- Cart and order history are isolated per signed-in user.
- Flutter splash now uses real animation instead of relying on a GIF.
- See `docs/AUTH_AND_ASSETS_GUIDE.md`.

## v1.1 authentication + interaction pass

The review pass adds real Google/Facebook Firebase flows, validated Remember Me behavior, per-user local data, persistent functional dark mode, persistent favorites, code-driven splash animation and Navigator 2.0 page transitions. See:

- `docs/CODE_WALKTHROUGH.md`
- `docs/FIREBASE_SOCIAL_SETUP.md`
- `docs/ASSETS_AND_ANIMATION.md`

## v1.2 Android build compatibility
- Enabled AGP built-in Kotlin for current Flutter / Facebook Auth plugin compatibility.
- Removed the legacy Kotlin Android plugin declaration from Gradle settings.
- Added an official Google Maven DNS/HTTPS preflight to `tool/setup_windows.ps1` so network failures are identified before Gradle starts.
- The setup script now performs `flutter build apk --debug` as a smoke test after `flutter analyze`.
- See `docs/ANDROID_BUILD_TROUBLESHOOTING.md`.
