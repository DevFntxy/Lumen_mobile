import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class PixelToggle extends StatelessWidget {
  const PixelToggle({
    super.key,
    required this.semanticLabel,
    required this.value,
    required this.onChanged,
  });

  final String semanticLabel;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    return Semantics(
      toggled: value,
      label: semanticLabel,
      enabled: enabled,
      onTap: enabled ? () => onChanged!(!value) : null,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => onChanged!(!value) : null,
        child: Container(
          width: 56,
          height: 32,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: value ? AppColors.primaryDark : AppColors.detail,
            border: Border.all(
              color: value ? AppColors.primaryLight : AppColors.metal,
              width: 3,
            ),
          ),
          child: Align(
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 18,
              height: 18,
              color: value ? AppColors.primaryLight : AppColors.metalLight,
            ),
          ),
        ),
      ),
    );
  }
}
