# Authentication, persistence, theme, favorites, splash and assets

## Authentication logic
- Email/password sign-up creates the Firebase account, updates `displayName`, signs out immediately, and returns the user to Sign In. This keeps **registration** and **login** as two explicit actions.
- Email/password sign-in is handled by Firebase Authentication.
- Google sign-in uses the official `google_sign_in` package and exchanges the Google ID token for a Firebase credential.
- Facebook sign-in uses `flutter_facebook_auth` and exchanges the Facebook access token for a Firebase credential.
- `Remember Me` is the application-level persistence switch. If checked, the current user's minimal session profile is stored in Realm. If not checked, the Realm session is deleted. On the next launch, absence of a Realm session causes the app to sign Firebase out so Firebase's own mobile persistence does not silently override the user's choice.
- The words "Realm session" are never shown to end users.

## User-specific local data
- Session profile: global Realm (`nexacart_session.realm`).
- Cart + orders: a separate Realm file per Firebase user ID (`nexacart_user_<uid>.realm`). This prevents two accounts on the same phone from seeing each other's cart/order history.
- Favorites: persisted per user ID using `SharedPreferencesAsync` as a lightweight bonus-feature store.
- Theme: persisted with `SharedPreferencesAsync`, following the service + Cubit pattern used in the supplied `mindset_packages` reference.

## Splash logic
There are two stages:
1. Native splash (`flutter_native_splash`) only covers the brief period before Flutter draws its first frame.
2. Flutter `SplashScreen` uses real Flutter `AnimationController`, fade, scale, and halo animation. It restores the Realm session and navigates as soon as initialization is complete, with only a short minimum visual duration.

No GIF is required for the runtime splash. The old GIF is kept only as an optional asset/reference.

## Where to replace images
- Main app / launcher logo: `assets/images/app_icon.png`
- Native splash image: `assets/images/native_splash_mark.png`
- Optional old GIF: `assets/images/nexacart_splash.gif`
- Generated UI references: `assets/design_reference/`

After replacing `app_icon.png` or `splash_logo.png`, run:
```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## Firebase configuration
The project accepts Firebase options through `--dart-define` so secrets/config values are not hard-coded in source:
- `FIREBASE_API_KEY`
- `FIREBASE_APP_ID`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_STORAGE_BUCKET` (optional)
- `GOOGLE_SERVER_CLIENT_ID` (needed for Google on Android when not using generated google-services config)
- `GOOGLE_IOS_CLIENT_ID` (iOS Google client ID when not using GoogleService-Info.plist)

Example:
```bash
flutter run \
  --dart-define=FIREBASE_API_KEY=... \
  --dart-define=FIREBASE_APP_ID=... \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=... \
  --dart-define=FIREBASE_PROJECT_ID=... \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=...
```

For Facebook, replace the placeholder App ID / Client Token in iOS `Info.plist`, and pass Android Gradle properties `FACEBOOK_APP_ID` and `FACEBOOK_CLIENT_TOKEN`, then enable Facebook in Firebase Authentication. These values must come from your own Meta/Firebase project; they cannot be invented safely.
