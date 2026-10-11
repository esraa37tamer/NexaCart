# NexaCart — code walkthrough and architectural reasoning

This document is intended for the graduation-project review. It explains what each major part does, how the files relate to each other, and why the architecture is structured this way.

## 1. Architectural rule

The main dependency direction is:

```text
Presentation -> Domain <- Data
```

The Domain layer contains business concepts, repository contracts and use cases. It imports neither Flutter UI nor Firebase/Realm/Dio. Data implements Domain contracts. Presentation talks to Domain through Cubits/use cases.

This gives the project the important SOLID properties without turning a solo project into an over-engineered framework.

## 2. Project layout

```text
lib/
  core/
    config/
    di/
    errors/
    navigation/
    network/
    storage/
    theme/
    utils/
    widgets/
  features/
    auth/
      data/
      domain/
      presentation/
    products/
      data/
      domain/
      presentation/
    cart/
      data/
      domain/
      presentation/
    orders/
      data/
      domain/
      presentation/
    favorites/
      data/
      domain/
      presentation/
    splash/
      presentation/
```

Every business feature owns its own files. `core/` contains only cross-feature infrastructure and shared UI pieces.

## 3. App startup

### `lib/main.dart`

1. Ensures Flutter bindings are initialized.
2. Calls `configureDependencies()`.
3. Starts `NexaCartApp`.

This keeps setup out of UI code.

### `lib/core/di/injection.dart`

This is the composition root. It wires interfaces to implementations once:

- Realm database
- SharedPreferencesAsync
- ThemeService
- Dio
- Firebase Auth data source
- repository implementations
- use cases

Screens/Cubits do not create Dio, Firebase, Realm or repositories themselves. This is Dependency Inversion in practice.

## 4. Authentication feature

### Domain

`features/auth/domain/entities/app_user.dart`

A clean business representation of the signed-in user. It has no Firebase types.

`features/auth/domain/repositories/auth_repository.dart`

Defines what authentication can do, not how it is implemented:

- restore session
- email/password sign-in
- Google sign-in
- Facebook sign-in
- sign-up
- sign-out

`features/auth/domain/use_cases/`

One use case per action. The Cubit receives these dependencies and does not know about Firebase.

### Data

`firebase_auth_remote_data_source.dart`

Only this low-level class knows Firebase/Google/Facebook APIs. It maps Firebase `User` into Domain `AppUser`.

`session_local_data_source.dart`

Only this class knows the Realm object used for the persisted login snapshot.

`auth_repository_impl.dart`

Coordinates remote authentication with local Remember Me behavior.

Important login rules:

- Registration creates the Firebase account, stores the display name, then signs out so the user explicitly logs in afterward.
- Remember Me checked -> save local Realm session.
- Remember Me unchecked -> do not save local session.
- On next launch, Realm is the app-level decision for whether the user asked to be remembered.
- A remembered user is validated against the current Firebase user and refreshed before being accepted.

This is necessary because native Firebase Auth persists its own authentication state automatically.

### Presentation

`auth_cubit.dart`

The Cubit owns UI state transitions: loading/authenticated/unauthenticated/registration-success/failure.

`login_screen.dart`

Contains form/UI only. Real actions:

- email validation
- password validation
- show/hide password
- Remember Me checkbox
- Firebase email/password sign-in
- Google sign-in
- Facebook sign-in
- theme toggle
- Create Account navigation

There are no pre-filled fake credentials and no storage-implementation text presented to the user.

`signup_screen.dart`

Real form with full name, email, password, confirmation and terms. Email registration is separate from login. Social provider buttons use their real provider authentication flow.

## 5. Splash behavior

There are two different splash concepts and they are intentionally separated.

### Native splash

Configured by `flutter_native_splash` in `pubspec.yaml`. Its only job is to cover the short period before Flutter draws its first frame.

Asset:

```text
assets/images/native_splash_mark.png
```

### Flutter splash / startup animation

`features/splash/presentation/splash_screen.dart`

This is actual Flutter code, not a pre-rendered GIF. It animates:

- fade
- scale
- a lightweight expanding halo

It starts restoring authentication immediately and only keeps a short minimum presentation time (~650 ms). It then routes immediately according to the real auth result. The animation does not artificially block startup for several seconds.

The runtime logo is the actual icon asset itself, so it is not put inside another incompatible decorative image frame.

## 6. Navigation

Files:

```text
core/navigation/app_navigation_controller.dart
core/navigation/app_route_parser.dart
core/navigation/app_router_delegate.dart
core/navigation/animated_page.dart
core/navigation/route_names.dart
```

This is Router/Navigator 2.0 using named paths such as `/login`, `/signup`, `/home`, `/details`, `/cart`, `/history`, `/favorites`.

`AppNavigationController` owns the page stack.

`AppRouteParser` converts a URL/name into stack entries and back.

`AppRouterDelegate` creates the Navigator pages.

`NexaPage` adds a small 260 ms fade/slide page transition. It is subtle on purpose: animation should support navigation rather than make the app feel slow.

## 7. Products feature

### Domain

`Product` is the business entity. The repository contract exposes product operations. Use cases include:

- GetProducts
- GetProduct
- SearchProducts
- GetCategories
- GetProductsByCategory

No Dio/JSON code exists in Domain.

### Data

`ProductsRemoteDataSource` talks to DummyJSON using Dio.

`ProductModel` owns JSON conversion.

`ProductsRepositoryImpl` implements the Domain contract and returns Domain entities.

### Presentation

`ProductsCubit` has explicit loading/success/failure behavior and owns current products/categories/search state.

The home screen uses a real Material `SearchBar` and a real `GridView.builder`.

Every product card action is functional:

- tap card -> Product Details
- cart button -> CartCubit
- heart -> FavoritesCubit and turns red
- selected category -> API/repository/cubit path
- refresh -> reload products

## 8. Product details

`product_detail_screen.dart` loads a product through `ProductDetailsCubit` + `GetProduct` use case.

Functional controls:

- back
- cart
- image PageView
- favorite heart
- quantity minus/plus
- Add to Cart

No screenshot is used as the interactive screen. The generated UI pictures in `assets/design_reference/` are references only.

## 9. Cart feature

The Cart domain contains `CartItem` and `CartRepository`.

`CartLocalDataSource` stores the cart in Realm.

A separate Realm file is created per Firebase UID. This avoids user A ever receiving user B's local cart on the same device.

`CartCubit` owns all synchronous cart actions required by the brief:

- add
- increase
- decrease
- remove
- clear
- total/count derived state
- checkout

Every edit is persisted immediately, so reopening the app restores the latest local cart for that user.

Checkout creates an order, clears the user's cart, and displays a real success dialog. Failure uses an error dialog rather than pretending checkout succeeded.

## 10. Orders feature

Orders also use the user's Realm database.

Flow:

```text
OrderHistoryScreen
  -> OrdersCubit
  -> GetOrders
  -> OrdersRepository
  -> OrdersRepositoryImpl
  -> OrdersLocalDataSource
  -> RealmDatabase.forUser(uid)
```

Orders contain products, total, status and date/time.

Checkout uses `CreateOrder`, so order creation is not embedded in the Cart UI.

## 11. Favorites feature

This is a bonus feature implemented as a real feature, not just a heart animation.

Flow:

```text
heart button
  -> FavoritesCubit.toggle(product)
  -> FavoritesRepository
  -> FavoritesRepositoryImpl
  -> FavoritesLocalDataSource
```

The heart uses `AnimatedSwitcher`, becomes red when selected, persists by UID, and the selected products appear on `/favorites`.

Favorites are simple noncritical local preference data, so they use `SharedPreferencesAsync`; required transactional application data (session/cart/orders) remains in Realm.

## 12. Theme / dark mode

Pattern follows the same service + Cubit separation used by the architecture reference project:

```text
Theme button
  -> ThemeCubit
  -> ThemeService abstraction
  -> ThemeServiceImpl
  -> SharedPreferencesAsync
```

`MaterialApp.router` listens to ThemeCubit and applies either `AppTheme.light()` or `AppTheme.dark()`.

The selection is persisted, so it is not a decorative moon icon anymore.

Shared widgets (`AppBackground`, `NeumorphicSurface`, inputs and text colors) read `Theme.of(context)`, allowing actual dark rendering rather than changing only one icon.

## 13. Realm design

`core/storage/realm_database.dart` deliberately uses:

- one small Realm file for the Remember Me session snapshot;
- one per-user Realm file for cart/orders.

This gives a very clear ownership boundary by Firebase UID and keeps local data restored at its latest save.

## 14. Assets and what can be replaced

### Real launcher/app logo

```text
assets/images/app_icon.png
```

Used by Flutter UI and `flutter_launcher_icons`.

After replacing it:

```bash
dart run flutter_launcher_icons
```

### Native splash image

```text
assets/images/native_splash_mark.png
```

After replacing it:

```bash
dart run flutter_native_splash:create
```

### Old optional GIF

```text
assets/images/nexacart_splash.gif
```

It is kept as an asset/reference but the runtime Flutter splash does NOT depend on it. The startup animation is code-driven so it can adapt to screen sizes and themes.

### UI references

```text
assets/design_reference/
```

These are design references only. Product cards, buttons, hearts, navigation and forms are all native Flutter widgets with real callbacks/state.

## 15. SOLID mapping

### SRP

Screens render, Cubits control UI state, use cases represent actions, repositories abstract data, data sources perform I/O.

### OCP

A repository implementation can be replaced (e.g. DummyJSON -> another API) without rewriting Cubits/use cases.

### LSP

Any implementation of a repository contract must satisfy the same Domain expectations.

### ISP

Repositories are feature-focused rather than one giant application service.

### DIP

Cubits/use cases depend on Domain contracts, not Firebase/Dio/Realm concrete classes.

### DRY

Validation, shared visual surfaces, navigation and service setup are centralized instead of copied across screens.

## 16. Why Cubit instead of Riverpod

The supplied learning material demonstrates immutable state using Notifier/AsyncNotifier, but the Client Brief explicitly requires Cubit. NexaCart applies the same state principles with Cubit:

- state is replaced rather than mutating UI directly;
- async features expose loading/success/failure;
- cart uses synchronous Cubit actions.

This satisfies the assignment instead of copying the tutorial technology literally.

## 17. SDK/build decisions

See `SDK_NOTES.md`. Android uses a modern compile/target SDK and Java 17. The setup script also handles the known Realm 20.2.0 Android compileSdk declaration mismatch that was already reproduced on the development machine.

## 18. Verification commands

On a machine with Flutter installed:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\tool\setup_windows.ps1
flutter run
```

The setup script runs dependency install, Realm install, icon/splash generation and `flutter analyze`.

For a quick repository-level structural check without Flutter:

```bash
python tool/static_project_check.py
```
