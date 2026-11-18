import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/navigation.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/pixel_header.dart';
import '../../../core/widgets/pixel_nav_card.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/pixel_progress_bar.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/state_views.dart';
import '../models/player_progress.dart';
import '../providers/player_providers.dart';

/// SCR-07. Métricas de campaña y accesos al mapa, ránking y logros.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(playerProgressProvider);

    return ScreenScaffold(
      centered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PixelHeader(
            title: 'Progreso',
            onBack: () => context.backOr(AppRoutes.home),
          ),
          const SizedBox(height: 20),
          AsyncValueView<PlayerProgress?>(
            value: progress,
            loadingMessage: 'Cargando progreso...',
            onRetry: () => ref.invalidate(playerProgressProvider),
            data: (data) => data == null
                ? const EmptyState(
                    title: 'Sin progreso sincronizado',
                    message:
                        'Cuando juegues LUMEN en tu PC y sincronices tu '
                        'cuenta, aquí aparecerá tu avance.',
                  )
                : _ProgressContent(progress: data),
          ),
        ],
      ),
    );
  }
}

class _ProgressContent extends StatelessWidget {
  const _ProgressContent({required this.progress});

  final PlayerProgress progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PixelPanel(
          title: 'Avance de campaña',
          accent: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Acto actual', style: AppTextStyles.label),
              const SizedBox(height: 4),
              Text(progress.actName, style: AppTextStyles.heading),
              const SizedBox(height: 12),
              PixelProgressBar(value: progress.actProgress),
              const SizedBox(height: 16),
              const Text('Finalización global', style: AppTextStyles.label),
              const SizedBox(height: 8),
              PixelProgressBar(value: progress.overallCompletion),
              const SizedBox(height: 8),
              Text(
                formatPercent(progress.overallCompletion),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - 12) / 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _ProgressMetric(
                  width: itemWidth,
                  label: 'Zonas restauradas',
                  value: '${progress.zonesUnlocked} / ${progress.zonesTotal}',
                ),
                _ProgressMetric(
                  width: itemWidth,
                  label: 'Misiones activas',
                  value: '${progress.activeQuests}',
                ),
                _ProgressMetric(
                  width: itemWidth,
                  label: 'Códex descubierto',
                  value: '${progress.codexUnlocked} / ${progress.codexTotal}',
                ),
                _ProgressMetric(
                  width: itemWidth,
                  label: 'Logros obtenidos',
                  value:
                      '${progress.achievementsUnlocked} / ${progress.achievementsTotal}',
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        PixelNavCard(
          title: 'Mapa de zonas',
          subtitle:
              '${progress.zonesUnlocked} de ${progress.zonesTotal} '
              'zonas restauradas',
          onTap: () => context.push(AppRoutes.zoneMap),
        ),
        const SizedBox(height: 12),
        PixelNavCard(
          title: 'Tabla de clasificación',
          subtitle: 'Consulta tu posición entre los operadores',
          onTap: () => context.push(AppRoutes.leaderboard),
        ),
        const SizedBox(height: 12),
        PixelNavCard(
          title: 'Logros',
          subtitle:
              '${progress.achievementsUnlocked} de '
              '${progress.achievementsTotal} logros obtenidos',
          onTap: () => context.push(AppRoutes.achievements),
        ),
      ],
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  const _ProgressMetric({
    required this.width,
    required this.label,
    required this.value,
  });

  final double width;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: PixelPanel(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            const SizedBox(height: 6),
            Text(value, style: AppTextStyles.heading),
          ],
        ),
      ),
    );
  }
}
