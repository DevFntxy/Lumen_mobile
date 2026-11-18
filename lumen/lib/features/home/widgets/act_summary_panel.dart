import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/pixel_progress_bar.dart';
import '../../player/models/player_progress.dart';

/// Resumen del acto actual: nombre, barra de avance, avance total y fecha de
/// la última sesión.
class ActSummaryPanel extends StatelessWidget {
  const ActSummaryPanel({super.key, required this.progress});

  final PlayerProgress progress;

  @override
  Widget build(BuildContext context) {
    final secondary = AppTextStyles.body.copyWith(color: AppColors.textSecondary);
    return PixelPanel(
      title: 'Resumen del acto',
      accent: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Acto actual', style: AppTextStyles.label),
          const SizedBox(height: 2),
          Text(progress.actName, style: AppTextStyles.heading),
          const SizedBox(height: 12),
          PixelProgressBar(value: progress.actProgress),
          const SizedBox(height: 12),
          Text('Avance total: ${formatPercent(progress.overallCompletion)}'),
          const SizedBox(height: 4),
          Text(
            'Última sesión: ${formatDateTime(progress.lastSession)}',
            style: secondary,
          ),
        ],
      ),
    );
  }
}
