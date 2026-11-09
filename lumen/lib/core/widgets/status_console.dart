import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

/// Línea de estado estilo terminal: indica qué está pasando o qué falló y
/// cómo corregirlo. Se anuncia a lectores de pantalla al cambiar.
class StatusConsole extends StatelessWidget {
  const StatusConsole({super.key, required this.message, this.isError = false});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final color = isError ? AppColors.errorText : AppColors.textPrimary;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.detail,
          border: Border.all(
            color: isError ? AppColors.primaryLight : AppColors.metal,
            width: 3,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isError ? '!' : '>',
              style: AppTextStyles.body.copyWith(
                color: isError ? AppColors.errorText : AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: AppTextStyles.body.copyWith(color: color)),
            ),
          ],
        ),
      ),
    );
  }
}
