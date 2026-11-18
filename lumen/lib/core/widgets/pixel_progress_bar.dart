import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Barra de progreso segmentada. `value` va de 0.0 a 1.0.
class PixelProgressBar extends StatelessWidget {
  const PixelProgressBar({super.key, required this.value, this.segments = 20});

  final double value;
  final int segments;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0).toDouble();
    final filled = (clamped * segments).round();
    return Semantics(
      label: 'Progreso',
      value: '${(clamped * 100).round()}%',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColors.detail,
            border: Border.all(color: AppColors.metal, width: 3),
          ),
          child: Row(
            children: [
              for (var i = 0; i < segments; i++)
                Expanded(
                  child: Container(
                    height: 14,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    color: i < filled ? AppColors.primaryLight : AppColors.surfaceRaised,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
