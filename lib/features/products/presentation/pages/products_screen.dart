import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/navigation/app_navigation_controller.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../domain/use_cases/get_categories.dart';
import '../../domain/use_cases/get_products.dart';
import '../../domain/use_cases/get_products_by_category.dart';
import '../../domain/use_cases/search_products.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductsCubit(
        getIt<GetProducts>(),
        getIt<SearchProducts>(),
        getIt<GetCategories>(),
        getIt<GetProductsByCategory>(),
      )..load(),
      child: const _ProductsView(),
    );
  }
}

class _ProductsView extends StatefulWidget {
  const _ProductsView();

  @override
  State<_ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<_ProductsView> {
  String? _loadedUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.read<AuthCubit>().state.user;
    if (user != null && _loadedUser != user.id) {
      _loadedUser = user.id;
      context.read<CartCubit>().switchUser(user.id);
      context.read<FavoritesCubit>().switchUser(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final user = context.watch<AuthCubit>().state.user;
    final cart = context.watch<CartCubit>().state;
    final favorites = context.watch<FavoritesCubit>().state;

    return Scaffold(
      endDrawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const SizedBox(height: 8),
              Text(
                'NexaCart',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(user?.fullName ?? 'Guest'),
              Text(
                user?.email ?? '',
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
              const Divider(height: 32),
              ListTile(
                leading: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.redAccent,
                ),
                title: const Text('Favorites'),
                onTap: () => getIt<AppNavigationController>().push(
                  RouteNames.favorites,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.history_rounded),
                title: const Text('Order History'),
                onTap: () => getIt<AppNavigationController>().push(
                  RouteNames.history,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart_outlined),
                title: const Text('Cart'),
                onTap: () => getIt<AppNavigationController>().push(
                  RouteNames.cart,
                ),
              ),
              ListTile(
                leading: Icon(
                  Theme.of(context).brightness == Brightness.dark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                title: const Text('Toggle theme'),
                onTap: () => context.read<ThemeCubit>().toggle(),
              ),
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text('Logout'),
                onTap: () async {
                  Navigator.of(context).pop();
                  context.read<CartCubit>().detachUser();
                  context.read<FavoritesCubit>().detachUser();
                  await context.read<AuthCubit>().signOut();
                  getIt<AppNavigationController>().replaceAll(RouteNames.login);
                },
              ),
            ],
          ),
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        width: 46,
                        height: 46,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'NexaCart',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () => getIt<AppNavigationController>().push(
                        RouteNames.favorites,
                      ),
                      icon: const Icon(Icons.favorite_border_rounded),
                    ),
                    Builder(
                      builder: (drawerContext) => IconButton.filledTonal(
                        onPressed: () => Scaffold.of(drawerContext).openEndDrawer(),
                        icon: const Icon(Icons.menu_rounded),
                      ),
                    ),
                    Badge(
                      label: Text('${cart.count}'),
                      isLabelVisible: cart.count > 0,
                      child: IconButton.filledTonal(
                        onPressed: () => getIt<AppNavigationController>().push(
                          RouteNames.cart,
                        ),
                        icon: const Icon(Icons.shopping_cart_outlined),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'Welcome ${user?.fullName.split(' ').first ?? ''}!',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                    color: colors.onSurface,
                  ),
                ),
                Text(
                  'Discover products for a better everyday life.',
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                SearchBar(
                  hintText: 'Search products...',
                  leading: const Icon(Icons.search_rounded),
                  trailing: [
                    IconButton(
                      onPressed: () => context.read<ProductsCubit>().load(),
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                  onChanged: context.read<ProductsCubit>().search,
                ),
                const SizedBox(height: 12),
                BlocBuilder<ProductsCubit, ProductsState>(
                  builder: (context, state) {
                    return SizedBox(
                      height: 46,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _categoryChip(context, 'all', state.selectedCategory),
                          ...state.categories.take(12).map(
                                (category) => _categoryChip(
                                  context,
                                  category,
                                  state.selectedCategory,
                                ),
                              ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'Popular Products',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: BlocBuilder<ProductsCubit, ProductsState>(
                    builder: (context, state) {
                      if (state.status == ProductsStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state.status == ProductsStatus.failure) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.message ?? 'Error',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: () =>
                                    context.read<ProductsCubit>().load(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.only(bottom: 18),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.70,
                        ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          final product = state.products[index];
                          return ProductCard(
                            product: product,
                            isFavorite: favorites.contains(product.id),
                            onFavorite: () => context
                                .read<FavoritesCubit>()
                                .toggle(product),
                            onTap: () => getIt<AppNavigationController>().push(
                              RouteNames.details,
                              id: product.id,
                            ),
                            onAdd: () =>
                                context.read<CartCubit>().add(product),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryChip(
    BuildContext context,
    String value,
    String selected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(value.replaceAll('-', ' ')),
        selected: value == selected,
        onSelected: (_) => context.read<ProductsCubit>().selectCategory(value),
      ),
    );
  }
}
