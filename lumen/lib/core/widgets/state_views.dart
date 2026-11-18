import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import 'pixel_button.dart';
import 'pixel_loading_dots.dart';
import 'pixel_panel.dart';

/// Estado de carga: indicador y mensaje de qué se está cargando.
class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.message = 'Cargando...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PixelLoadingDots(size: 14),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center, style: AppTextStyles.label),
        ],
      ),
    );
  }
}

/// Estado de error: qué pasó y, si hay [onRetry], cómo reintentar.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      title: 'No se pudo cargar',
      accent: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(message, style: AppTextStyles.body),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            PixelButton(label: 'Reintentar', onPressed: onRetry),
          ],
        ],
      ),
    );
  }
}

/// Estado vacío: explica por qué no hay contenido y qué hacer.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      title: title,
      child: Text(
        message,
        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
