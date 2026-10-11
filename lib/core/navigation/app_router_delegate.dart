import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/cart/presentation/pages/cart_screen.dart';
import '../../features/favorites/presentation/pages/favorites_screen.dart';
import '../../features/orders/presentation/pages/order_history_screen.dart';
import '../../features/products/presentation/pages/product_detail_screen.dart';
import '../../features/products/presentation/pages/products_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import 'animated_page.dart';
import 'app_navigation_controller.dart';
import 'route_names.dart';

class AppRouterDelegate extends RouterDelegate<List<AppRouteEntry>>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<List<AppRouteEntry>> {
  AppRouterDelegate(this.navigation) {
    navigation.addListener(notifyListeners);
  }

  final AppNavigationController navigation;

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  List<AppRouteEntry> get currentConfiguration => navigation.stack;

  @override
  Future<void> setNewRoutePath(List<AppRouteEntry> configuration) async {
    if (configuration.isEmpty) return;
    final first = configuration.first;
    navigation.replaceAll(first.name, id: first.id);
    for (final entry in configuration.skip(1)) {
      navigation.push(entry.name, id: entry.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Page<void>>[];

    for (final route in navigation.stack) {
      final child = switch (route.name) {
        RouteNames.splash => const SplashScreen(),
        RouteNames.login => const LoginScreen(),
        RouteNames.signup => const SignUpScreen(),
        RouteNames.home => const ProductsScreen(),
        RouteNames.cart => const CartScreen(),
        RouteNames.history => const OrderHistoryScreen(),
        RouteNames.favorites => const FavoritesScreen(),
        RouteNames.details => ProductDetailScreen(productId: route.id ?? 1),
        _ => const LoginScreen(),
      };

      pages.add(
        NexaPage<void>(
          key: ValueKey('${route.name}-${route.id ?? ''}'),
          name: route.name,
          child: child,
        ),
      );
    }

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onDidRemovePage: (page) {
        final current = navigation.stack;
        if (current.length > 1 && current.last.name == page.name) {
          navigation.pop();
        }
      },
    );
  }
}
