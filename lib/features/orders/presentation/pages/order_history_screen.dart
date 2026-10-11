import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/navigation/app_navigation_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/neumorphic_surface.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/use_cases/get_orders.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrdersCubit(getIt<GetOrders>())..load(context.read<AuthCubit>().state.user!.id),
      child: Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
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
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Order History',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'View and track all your orders',
                    style: TextStyle(
                      letterSpacing: 1.5,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<OrdersCubit, OrdersState>(
                      builder: (context, state) {
                        if (state.status == OrdersStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state.status == OrdersStatus.failure) {
                          return Center(child: Text(state.message ?? 'Error'));
                        }
                        if (state.orders.isEmpty) {
                          return const Center(
                            child: Text(
                              'No orders yet. Complete a checkout first.',
                            ),
                          );
                        }
                        return ListView.separated(
                          itemCount: state.orders.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, index) {
                            final order = state.orders[index];
                            final thumbnail = order.items.isEmpty
                                ? ''
                                : order.items.first.thumbnail;
                            return NeumorphicSurface(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: thumbnail.isEmpty
                                        ? const SizedBox(
                                            width: 82,
                                            height: 82,
                                            child: Icon(
                                              Icons.shopping_bag_outlined,
                                            ),
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: thumbnail,
                                            width: 82,
                                            height: 82,
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Order #${order.id}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          _date(order.createdAt),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        Text(
                                          '${order.items.length} items',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '\$${order.total.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD9F6EC),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      order.status,
                                      style: const TextStyle(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }

  static String _date(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/${date.year}  $hour:$minute';
  }
}
