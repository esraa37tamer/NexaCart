import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/navigation/app_navigation_controller.dart';
import '../../../core/navigation/route_names.dart';
import '../../../core/widgets/app_background.dart';
import '../../auth/presentation/cubit/auth_cubit.dart';
import '../../auth/presentation/cubit/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    final minimumDisplayTime = Future<void>.delayed(
      const Duration(milliseconds: 650),
    );
    await context.read<AuthCubit>().restoreSession();
    await minimumDisplayTime;
    if (!mounted) return;

    final auth = context.read<AuthCubit>().state;
    getIt<AppNavigationController>().replaceAll(
      auth.status == AuthStatus.authenticated
          ? RouteNames.home
          : RouteNames.login,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: AppBackground(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _scale,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.72, end: 1.12),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Container(
                            width: 190 * value,
                            height: 190 * value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.primary.withValues(alpha: 0.035),
                              border: Border.all(
                                color: colors.primary.withValues(alpha: 0.12),
                              ),
                            ),
                          );
                        },
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(42),
                        child: Image.asset(
                          'assets/images/app_icon.png',
                          width: 154,
                          height: 154,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                    children: [
                      TextSpan(
                        text: 'Nexa',
                        style: TextStyle(color: colors.onSurface),
                      ),
                      TextSpan(
                        text: 'Cart',
                        style: TextStyle(color: colors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'SHOP • DISCOVER • ENJOY',
                  style: TextStyle(
                    letterSpacing: 3,
                    fontSize: 10,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
