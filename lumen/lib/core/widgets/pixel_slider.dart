import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class PixelSlider extends StatelessWidget {
  const PixelSlider({
    super.key,
    required this.semanticLabel,
    required this.value,
    required this.onChanged,
    this.onChangeEnd,
  });

  final String semanticLabel;
  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0).toDouble();
    return Semantics(
      label: semanticLabel,
      value: '${(clamped * 100).round()}%',
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: AppColors.primaryLight,
          inactiveTrackColor: AppColors.metal,
          thumbColor: AppColors.textPrimary,
          overlayColor: AppColors.primaryLight.withAlpha(40),
          trackHeight: 8,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
        ),
        child: Slider(
          value: clamped,
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
        ),
      ),
    );
  }
}
