import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../player/models/player_profile.dart';

/// Lista de proveedores externos y la cuenta vinculada a cada uno.
class LinkedProvidersPanel extends StatelessWidget {
  const LinkedProvidersPanel({super.key, required this.providers});

  final List<LinkedProvider> providers;

  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      title: 'Cuentas vinculadas',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, item) in providers.indexed) ...[
            if (index > 0) const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 84,
                  child: Text(item.provider.label, style: AppTextStyles.heading),
                ),
                Expanded(
                  child: Text(
                    item.accountLabel ?? 'No vinculada',
                    style: AppTextStyles.body.copyWith(
                      color: item.isLinked
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
