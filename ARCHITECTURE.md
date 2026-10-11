# Architecture & SOLID Decisions

## Domain Layer
The Domain Layer describes business concepts and operations without knowing Firebase, Realm, Dio, or Flutter UI. This keeps business logic testable and replaceable.

## SRP — Single Responsibility
- `ProductsRemoteDataSource`: HTTP communication only.
- `ProductsRepositoryImpl`: repository implementation only.
- `GetProducts`: one application operation.
- `ProductsCubit`: presentation state transitions only.
- Screens: rendering and user interaction only.

## OCP — Open/Closed
Repository contracts allow another implementation (mock/local/new API) without changing use cases or Cubits.

## LSP — Liskov Substitution
`FirebaseAuthRemoteDataSource` and `DemoAuthRemoteDataSource` implement the same contract and are interchangeable through dependency injection.

## ISP — Interface Segregation
Repositories are feature-focused: Auth, Products, Cart, Orders. There is no giant service interface.

## DIP — Dependency Inversion
Use cases depend on repository abstractions. Realm/Dio/Firebase implementations are wired only in `core/di/injection.dart`.

## DRY
Validation, theme, neumorphic surfaces, logo, and gradient buttons are shared rather than duplicated.

## Why Cubit instead of Riverpod?
The supplied tutorial uses Riverpod to explain immutable state, but the client brief explicitly requires Cubit. This project applies the same immutable-state ideas using Cubit.

## Why custom Navigator 2.0?
The brief explicitly asks for named navigation with Navigator 2.0. The project therefore includes its own `RouterDelegate`, `RouteInformationParser`, and route-name constants instead of hiding the requirement behind a routing package.

## How MVC maps to this project
The client brief asks for Repository + MVC and also explicitly requires Cubit plus a Domain layer. To avoid duplicate controller classes, the project maps the concepts as follows:

- **Model:** Domain entities + Data models/Realm records.
- **View:** Presentation pages and reusable widgets.
- **Controller:** Feature Cubits. Cubits receive UI actions and coordinate use cases/state transitions.
- **Repository:** Contract in Domain; implementation in Data.

This keeps the MVC terminology the reviewer expects while preserving Dependency Inversion and a clean Domain boundary.
