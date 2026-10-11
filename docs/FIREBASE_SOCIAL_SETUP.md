# Firebase, Google and Facebook setup

The source code contains the real Firebase Authentication flows. Project-specific credentials are intentionally not committed.

## 1) Firebase

1. Create a Firebase project.
2. Add Android app `com.nexacart.app` and the matching iOS bundle identifier.
3. In Firebase Authentication > Sign-in method, enable:
   - Email/Password
   - Google
   - Facebook
4. Add SHA-1/SHA-256 fingerprints for Android when configuring Google sign-in.

NexaCart initializes Firebase from Dart defines so secrets/config values do not have to be hard-coded in source:

```powershell
flutter run `
  --dart-define=FIREBASE_API_KEY=YOUR_API_KEY `
  --dart-define=FIREBASE_APP_ID=YOUR_FIREBASE_APP_ID `
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=YOUR_SENDER_ID `
  --dart-define=FIREBASE_PROJECT_ID=YOUR_PROJECT_ID `
  --dart-define=FIREBASE_STORAGE_BUCKET=YOUR_BUCKET `
  --dart-define=GOOGLE_SERVER_CLIENT_ID=YOUR_WEB_OAUTH_CLIENT_ID `
  --dart-define=GOOGLE_IOS_CLIENT_ID=YOUR_IOS_OAUTH_CLIENT_ID
```

`lib/core/config/firebase_runtime_config.dart` reads those values and creates `FirebaseOptions`.

## 2) Google Sign-In

`google_sign_in` is initialized once by `FirebaseAuthRemoteDataSource`. The Google ID token is converted to a Firebase `GoogleAuthProvider` credential, then Firebase becomes the authoritative authenticated user.

Android Google Sign-In also requires the correct package name and SHA fingerprints in Firebase/Google Cloud.

iOS can use the Dart `clientId`/`serverClientId` approach already used in this project. If you choose the `GoogleService-Info.plist` approach instead, follow the official Google Sign-In iOS setup including its reversed-client-ID URL scheme.

## 3) Facebook Sign-In

Create a Meta/Facebook application, then enable Facebook in Firebase Authentication using the Meta App ID and App Secret.

### Android

Pass the native Meta values as Gradle properties or environment values supported by your local setup. The project already contains the required Facebook metadata placeholders in `AndroidManifest.xml`.

Example `android/gradle.properties` entries (do not commit real secrets):

```properties
FACEBOOK_APP_ID=YOUR_FACEBOOK_APP_ID
FACEBOOK_CLIENT_TOKEN=YOUR_FACEBOOK_CLIENT_TOKEN
```

### iOS

Before real Facebook login, replace these placeholders in `ios/Runner/Info.plist`:

- `FacebookAppID`
- `FacebookClientToken`
- the `fb000000000000000` URL scheme with `fb<YOUR_APP_ID>`

The required `LSApplicationQueriesSchemes` entries are already present.

## 4) Authentication behavior in NexaCart

### Email/password registration

`Create Account` calls Firebase `createUserWithEmailAndPassword`, updates the Firebase display name, then intentionally signs out. This makes registration and login two distinct steps as required by the project brief.

### Email/password login

`Sign In` calls Firebase `signInWithEmailAndPassword`.

### Google/Facebook

Social providers combine account creation and sign-in in the normal provider flow. Firebase creates/links the Firebase user on first successful provider authentication and signs that user in.

### Remember Me

Firebase native SDKs persist authentication automatically on Android/iOS. To make the visible Remember Me checkbox meaningful:

- checked: NexaCart stores a small user-session snapshot in Realm;
- unchecked: NexaCart stores no Realm session;
- next launch with no Realm session: NexaCart explicitly signs Firebase out and shows Sign In;
- next launch with a Realm session: NexaCart reloads/validates `FirebaseAuth.currentUser`; if the provider session is invalid, the Realm session is cleared.

No database or implementation words such as "Realm session" are shown to the end user.
