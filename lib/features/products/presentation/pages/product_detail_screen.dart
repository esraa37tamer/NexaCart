import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/navigation/app_navigation_controller.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_state.dart';
import '../../domain/use_cases/get_product.dart';
import '../cubit/product_details_cubit.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailsCubit(getIt<GetProduct>())..load(productId),
      child: const _ProductDetailView(),
    );
  }
}

class _ProductDetailView extends StatefulWidget {
  const _ProductDetailView();

  @override
  State<_ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<_ProductDetailView> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
            builder: (context, state) {
              if (state is ProductDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ProductDetailsFailure) {
                return Center(child: Text(state.message));
              }

              final product = (state as ProductDetailsSuccess).product;
              final images = product.images.isEmpty
                  ? <String>[product.thumbnail]
                  : product.images;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed: getIt<AppNavigationController>().pop,
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const Spacer(),
                        Text(
                          'NexaCart',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: colors.onSurface,
                          ),
                        ),
                        const Spacer(),
                        IconButton.filledTonal(
                          onPressed: () => getIt<AppNavigationController>()
                              .push(RouteNames.cart),
                          icon: const Icon(Icons.shopping_cart_outlined),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Stack(
                      children: [
                    Container(
                      height: 340,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withValues(alpha: .72),
                        borderRadius: BorderRadius.circular(34),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.blue.withValues(alpha: .16),
                            blurRadius: 26,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: PageView(
                        children: images
                            .map(
                              (url) => CachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.contain,
                                errorWidget: (_, _, _) => const Icon(
                                  Icons.image_not_supported,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Positioned(
                      top: 18,
                      right: 18,
                      child: BlocBuilder<FavoritesCubit, FavoritesState>(
                        builder: (context, favoriteState) {
                          final isFavorite = favoriteState.contains(product.id);
                          return IconButton.filledTonal(
                            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
                            onPressed: () => context.read<FavoritesCubit>().toggle(product),
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                              child: Icon(
                                isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                key: ValueKey(isFavorite),
                                color: isFavorite ? Colors.redAccent : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            index < product.rating.round()
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: AppColors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.description,
                      style: TextStyle(
                        height: 1.5,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Text(
                          'Quantity',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: colors.onSurface,
                          ),
                        ),
                        const Spacer(),
                        IconButton.filledTonal(
                          onPressed: quantity > 1
                              ? () => setState(() => quantity--)
                              : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            '$quantity',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        IconButton.filledTonal(
                          onPressed: () => setState(() => quantity++),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    GradientButton(
                      label: 'Add to Cart',
                      onPressed: () {
                        context
                            .read<CartCubit>()
                            .add(product, quantity: quantity);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart')),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
