# NexaCart Graduation Project — Client Brief

Required screens:
- SignInScreen
- SignUpScreen
- ProductListScreen
- ProductDetailScreen
- CartScreen
- OrderHistoryScreen

Required behavior:
- Email/password sign in and sign up with full name.
- Logout redirects to sign in.
- Signed-in session persists after app restart using Realm.
- Products loaded from repository using DummyJSON/mock API.
- Search products by name.
- Product detail opened through Navigator navigation.
- Cart add, increase/decrease quantity, total, checkout success dialog.
- Cart actions handled by Cubit.
- Dedicated Products Cubit with loading/success/error.
- Order history shows products, total, and time and is accessible through end drawer.

Architecture/technical requirements:
- Named navigation with Navigator 2.0.
- Cubit state management.
- Repository + feature-based MVC/Clean-style organization.
- Feature folders own Data, Domain, and Presentation concerns.
- Realm local storage for session, cart and/or order history.
- Apply SOLID and DRY without over-engineering.

API sources:
- https://dummyjson.com/docs/products
- https://firebase.google.com/docs/auth/flutter/password-auth

UI widgets/reference:
- Material SearchBar
- GridView.builder
