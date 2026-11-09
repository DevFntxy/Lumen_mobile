import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/pixel_button.dart';
import '../models/sso_provider.dart';

/// Separador "o entra con" y una fila de botones, uno por proveedor.
/// `onSelected: null` deshabilita todos (por ejemplo, mientras se carga).
class SsoButtons extends StatelessWidget {
  const SsoButtons({super.key, required this.onSelected});

  final ValueChanged<SsoProvider>? onSelected;

  @override
  Widget build(BuildContext context) {
    final handler = onSelected;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(child: _Rule()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const Text('O ENTRA CON', style: AppTextStyles.label),
            ),
            const Expanded(child: _Rule()),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            for (final (index, provider) in SsoProvider.values.indexed) ...[
              if (index > 0) const SizedBox(width: 6),
              Expanded(
                child: PixelButton(
                  label: provider.label,
                  variant: PixelButtonVariant.secondary,
                  compact: true,
                  onPressed: handler == null ? null : () => handler(provider),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule();

  @override
  Widget build(BuildContext context) {
    return Container(height: 3, color: AppColors.metal);
  }
}
