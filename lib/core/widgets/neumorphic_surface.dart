import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NeumorphicSurface extends StatelessWidget {
  const NeumorphicSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 24,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final box = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF172033).withValues(alpha: .96) : AppColors.surface.withValues(alpha: .96),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: dark ? const Color(0xFF2A3852) : Colors.white.withValues(alpha: 0.9)),
        boxShadow: [
          BoxShadow(
            color: dark ? Colors.black.withValues(alpha: .28) : const Color(0xFF6D94D8).withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(8, 10),
          ),
          BoxShadow(
            color: dark ? const Color(0xFF223252).withValues(alpha: .35) : Colors.white.withValues(alpha: 0.95),
            blurRadius: 10,
            offset: const Offset(-5, -5),
          ),
        ],
      ),
      child: child,
    );
    if (onTap == null) return box;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: box,
      ),
    );
  }
}
