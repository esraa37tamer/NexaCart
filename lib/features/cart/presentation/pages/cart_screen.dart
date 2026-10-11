import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/navigation/app_navigation_controller.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/neumorphic_surface.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: BlocConsumer<CartCubit, CartState>(
            listener: (context, state) {
              if (state.checkoutMessage == null) return;
              showDialog<void>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  icon: Icon(
                    state.checkoutFailed
                        ? Icons.error_outline_rounded
                        : Icons.check_circle_rounded,
                    color: state.checkoutFailed ? Colors.redAccent : Colors.green,
                    size: 54,
                  ),
                  title: Text(state.checkoutFailed ? 'Checkout failed' : 'Success'),
                  content: Text(state.checkoutMessage!),
                  actions: [
                    FilledButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        if (!state.checkoutFailed) {
                          getIt<AppNavigationController>()
                              .replaceAll(RouteNames.home);
                        }
                      },
                      child: Text(state.checkoutFailed ? 'Close' : 'Continue shopping'),
                    ),
                  ],
                ),
              );
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed: getIt<AppNavigationController>().pop,
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const Spacer(),
                        Text(
                          'NexaCart',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 23,
                            color: colors.onSurface,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your Cart',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: colors.onSurface,
                      ),
                    ),
                    Text(
                      '${state.count} items in your cart',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: state.items.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 64,
                                    color: AppColors.muted,
                                  ),
                                  SizedBox(height: 12),
                                  Text('Your cart is empty'),
                                ],
                              ),
                            )
                          : ListView.separated(
                              itemCount: state.items.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (_, index) {
                                final item = state.items[index];
                                return NeumorphicSurface(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: CachedNetworkImage(
                                          imageUrl: item.thumbnail,
                                          width: 88,
                                          height: 88,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                color: colors.onSurface,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              '\$${item.price.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: AppColors.blue,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                IconButton.filledTonal(
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  onPressed: () => context
                                                      .read<CartCubit>()
                                                      .decrease(item.productId),
                                                  icon:
                                                      const Icon(Icons.remove),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 10),
                                                  child: Text(
                                                    '${item.quantity}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                IconButton.filledTonal(
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  onPressed: () => context
                                                      .read<CartCubit>()
                                                      .increase(item.productId),
                                                  icon: const Icon(Icons.add),
                                                ),
                                                const Spacer(),
                                                IconButton(
                                                  onPressed: () => context
                                                      .read<CartCubit>()
                                                      .remove(item.productId),
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    color: AppColors.danger,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    NeumorphicSurface(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text('Subtotal'),
                              const Spacer(),
                              Text('\$${state.total.toStringAsFixed(2)}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Text('Shipping'),
                              Spacer(),
                              Text('\$0.00'),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '\$${state.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    GradientButton(
                      label: 'Proceed to Checkout',
                      loading: state.checkingOut,
                      onPressed: state.items.isEmpty
                          ? null
                          : () => context.read<CartCubit>().checkout(),
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
