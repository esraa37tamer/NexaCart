# Trusted implementation references checked on 2026-10-07

## SDK / platform

- Flutter stable release notes: https://docs.flutter.dev/release/release-notes
- Flutter 3.47 release notes: https://docs.flutter.dev/release/release-notes/release-notes-3.47.0
- Dart 3.13 announcement: https://dart.dev/blog/announcing-dart-3-13
- Android 17 SDK/API 37 setup: https://developer.android.com/about/versions/17/setup-sdk
- Google Play target API requirements: https://developer.android.com/google/play/requirements/target-sdk

## Client-required APIs / widgets

- DummyJSON Products: https://dummyjson.com/docs/products
- Firebase Flutter email/password auth: https://firebase.google.com/docs/auth/flutter/password-auth
- Flutter SearchBar: https://api.flutter.dev/flutter/material/SearchBar-class.html
- Flutter GridView: https://api.flutter.dev/flutter/widgets/GridView-class.html
- Flutter Navigator/Router: https://api.flutter.dev/flutter/widgets/Router-class.html

## Packages pinned in pubspec

- flutter_bloc 9.1.1: https://pub.dev/packages/flutter_bloc
- equatable 3.0.0: https://pub.dev/packages/equatable
- dio 5.11.1: https://pub.dev/packages/dio
- get_it 9.3.0: https://pub.dev/packages/get_it
- realm 20.2.0: https://pub.dev/packages/realm
- firebase_core 4.15.0: https://pub.dev/packages/firebase_core
- firebase_auth 6.7.0: https://pub.dev/packages/firebase_auth
- cached_network_image 4.0.4: https://pub.dev/packages/cached_network_image
- flutter_native_splash 2.4.8: https://pub.dev/packages/flutter_native_splash
- flutter_launcher_icons 0.14.4: https://pub.dev/packages/flutter_launcher_icons

## Realm compatibility note

Realm 20.2.0 is the current stable release used by this project and supports Android 16 KB page sizes, but its Android Gradle configuration still declares an old compile SDK. On the user's modern AndroidX/AGP toolchain this produced `:realm:checkDebugAarMetadata` because Realm compiled against API 31. The included setup scripts patch the local hosted Realm Gradle declaration to API 37 after dependency download. This reproduces the compatibility fix already proven on the user's machine while keeping the application itself on current Android SDK settings.
