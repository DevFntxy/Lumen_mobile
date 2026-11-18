import 'package:flutter/material.dart';

import '../../app/theme/app_text_styles.dart';
import 'pixel_button.dart';
import 'pixel_panel.dart';

/// Diálogo informativo con el estilo de la app y un solo botón de cierre.
Future<void> showPixelDialog({
  required BuildContext context,
  required String title,
  required String message,
  String actionLabel = 'Entendido',
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(20),
      shape: const RoundedRectangleBorder(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: PixelPanel(
          title: title,
          accent: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(message, style: AppTextStyles.body),
              const SizedBox(height: 20),
              PixelButton(
                label: actionLabel,
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Diálogo de confirmación para acciones destructivas. Devuelve `true` solo
/// si la persona confirma.
Future<bool> showPixelConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  String cancelLabel = 'Cancelar',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(20),
      shape: const RoundedRectangleBorder(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: PixelPanel(
          title: title,
          accent: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(message, style: AppTextStyles.body),
              const SizedBox(height: 20),
              PixelButton(
                label: confirmLabel,
                onPressed: () => Navigator.of(dialogContext).pop(true),
              ),
              const SizedBox(height: 8),
              PixelButton(
                label: cancelLabel,
                variant: PixelButtonVariant.secondary,
                onPressed: () => Navigator.of(dialogContext).pop(false),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  return result ?? false;
}
