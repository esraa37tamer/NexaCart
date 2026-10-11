# Client Brief → Implementation Traceability

This file exists so a reviewer can verify the graduation requirements quickly.

| Requirement | Implementation |
|---|---|
| Sign in with email/password | `features/auth/presentation/pages/login_screen.dart` → `AuthCubit` → `SignIn` → `AuthRepository` |
| Sign up with name/email/password | `signup_screen.dart` → `AuthCubit` → `SignUp` → repository |
| Logout and redirect | End drawer → `AuthCubit.signOut()` → `/login` |
| Remain signed in | Real Remember Me option: checked saves Realm `SessionRecord`; unchecked intentionally signs Firebase out on the next launch; remembered users are revalidated against Firebase |
| Products via Repository | DummyJSON/Dio inside `ProductsRemoteDataSource`; UI never calls Dio |
| Search by name | Material `SearchBar` → debounced `ProductsCubit.search()` → `/products/search` |
| Product details | Named Navigator 2.0 `/details/:id` page |
| Add to cart | Product details → `CartCubit.add()` |
| Increase/decrease | `CartCubit.increase/decrease()` |
| Total before checkout | Derived `CartState.total` |
| Checkout success dialog | `CartCubit.checkout()` then `AlertDialog` |
| Cart state with Cubit | `features/cart/presentation/cubit/` |
| Products loading/success/error Cubit | `ProductsStatus` in `products_state.dart` |
| Order history | Realm order records + `OrdersCubit` + `OrderHistoryScreen` |
| Order products/total/time | `OrderEntity` contains `items`, `total`, `createdAt` |
| History in end drawer | `ProductsScreen.endDrawer` |
| Named Navigator 2.0 | `core/navigation/route_names.dart`, `AppRouterDelegate`, `AppRouteParser` |
| Feature-based structure | `features/auth`, `features/products`, `features/cart`, `features/orders`, `features/favorites` |
| Domain Layer | Every core business feature has `domain/entities`, `domain/repositories`, and use cases where application operations are needed |
| Repository + MVC intent | Model/data = Data layer, View = pages/widgets, Controller = Cubit; repository contract in Domain |
| Realm local storage | `core/storage` + local data sources |
| Network errors | Data source throws `AppException`; Cubit emits failure; UI has retry state |
| SearchBar | Material 3 `SearchBar` in Products screen |
| GridView | `GridView.builder` in Products screen |
| Google sign-in | `google_sign_in` -> Firebase Google credential -> `AuthRepository` |
| Facebook sign-in | `flutter_facebook_auth` -> Firebase Facebook credential -> `AuthRepository` |
| Persistent favorites | Heart -> `FavoritesCubit`; red selected heart; per-user persistence; `/favorites` page |
| Functional dark mode | `ThemeCubit` -> `ThemeService` -> `SharedPreferencesAsync` -> `MaterialApp.themeMode` |
| Real splash animation | Flutter fade/scale/halo; native splash only covers engine startup |
| Route animations | `NexaPage` fade + slide while retaining Navigator 2.0 |

## Dependency direction

```text
Presentation (View + Cubit/Controller)
            ↓
        Use Cases
            ↓
Repository Contract (Domain)
            ↑
Repository Implementation (Data)
            ↓
Data Source (Dio / Firebase / Realm)
```

`Domain` never imports Flutter UI, Dio, Firebase, or Realm.
