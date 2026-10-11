import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 110, this.showName = true});
  final double size;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(size * .22),
          child: Image.asset('assets/images/app_icon.png', width: size, height: size, fit: BoxFit.cover),
        ),
        if (showName) ...[
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              children: [
                TextSpan(text: 'Nexa', style: TextStyle(color: onSurface)),
                const TextSpan(text: 'Cart', style: TextStyle(color: AppColors.blue)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
