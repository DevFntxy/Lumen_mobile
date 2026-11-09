import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

/// Panel industrial: borde grueso, sombra dura y cabecera opcional.
/// Con `accent` el borde y la cabecera usan el rojo de la identidad.
class PixelPanel extends StatelessWidget {
  const PixelPanel({
    super.key,
    required this.child,
    this.title,
    this.accent = false,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final String? title;
  final bool accent;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final borderColor = accent ? AppColors.primaryLight : AppColors.metal;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: borderColor, width: 3),
        boxShadow: const [
          BoxShadow(color: AppColors.detail, offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Container(
              color: accent ? AppColors.primaryDark : AppColors.metal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                title!.toUpperCase(),
                style: AppTextStyles.label.copyWith(color: AppColors.unselected),
              ),
            ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}
