import 'package:flutter/material.dart';

/// A lightweight Navigator 2.0 page transition used across NexaCart.
/// It keeps navigation in Flutter's Router/Navigator stack while adding a
/// subtle fade + slide that does not slow down normal app navigation.
class NexaPage<T> extends Page<T> {
  const NexaPage({
    required this.child,
    required super.key,
    required super.name,
  });

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 210),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final offset = Tween<Offset>(
          begin: const Offset(0.035, 0.02),
          end: Offset.zero,
        ).animate(curved);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(position: offset, child: child),
        );
      },
    );
  }
}
