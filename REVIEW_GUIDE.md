# Reviewer Q&A

**Why is Product different from ProductModel?**  
`Product` is a domain entity and has no JSON/API knowledge. `ProductModel` belongs to Data and maps DummyJSON payloads.

**Why do repository interfaces live in Domain?**  
The business layer declares what it needs. Data decides how to fulfill that need. This is Dependency Inversion.

**Why use a Use Case if it is one line?**  
It gives every application operation a stable boundary. Business rules can grow there without changing UI code.

**Why is Realm outside Domain?**  
Realm is an implementation detail. Domain knows repository contracts, not database APIs.

**How is session persistence satisfied?**  
Successful authentication is saved as a Realm `SessionRecord`. Splash restores it and routes directly to Home.

**How is cart persistence satisfied?**  
Every CartCubit mutation saves the immutable cart through `CartRepository` to Realm.

**Why does ProductsCubit have loading/success/failure?**  
Network access is asynchronous and the brief explicitly requires those states.

**Where is SearchBar used?**  
`ProductsScreen` uses Material 3 `SearchBar`; input is debounced in ProductsCubit and calls the repository search endpoint.

**Where is GridView used?**  
Products use `GridView.builder`, so cards are created on demand.

**How does checkout work?**  
CartCubit calls `CreateOrder`, the order is persisted in Realm, the cart is cleared, and UI shows a success dialog.
