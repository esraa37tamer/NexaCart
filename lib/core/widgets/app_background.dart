import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: dark
                    ? const [Color(0xFF07101E), Color(0xFF0B1220), Color(0xFF121D31)]
                    : const [Color(0xFFFDFEFF), AppColors.background, Color(0xFFEAF3FF)],
              ),
            ),
          ),
        ),
        Positioned(top: -110, left: -85, child: _orb(260, dark)),
        Positioned(top: 130, right: -72, child: _orb(150, dark)),
        Positioned(bottom: -120, right: -70, child: _orb(260, dark)),
        child,
      ],
    );
  }

  Widget _orb(double size, bool dark) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: dark
                ? const [Color(0xFF13213A), Color(0xFF0A1630)]
                : const [Colors.white, Color(0xFFCFE1FF)],
          ),
          border: Border.all(color: dark ? const Color(0xFF22385E) : Colors.white, width: 2),
          boxShadow: [
            BoxShadow(color: AppColors.blue.withValues(alpha: dark ? .12 : .14), blurRadius: 30),
          ],
        ),
      );
}
