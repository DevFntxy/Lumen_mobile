import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/navigation.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/async_form_mixin.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/pixel_header.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/pixel_progress_bar.dart';
import '../../../core/widgets/pixel_tile.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/status_console.dart';
import '../../auth/providers/auth_providers.dart';
import '../models/achievement_collection.dart';
import '../providers/achievement_providers.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen>
    with AsyncFormMixin<AchievementsScreen> {
  Future<void> _openAchievement(AchievementEntry entry) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(entry.name, style: AppTextStyles.heading),
              const SizedBox(height: 8),
              Text(entry.description, style: AppTextStyles.body),
              const SizedBox(height: 12),
              Text('Recompensa: ${entry.reward}', style: AppTextStyles.label),
              const SizedBox(height: 16),
              if (!entry.isComplete)
                Text(
                  'Progreso: ${entry.progress} / ${entry.target}',
                  style: AppTextStyles.caption,
                )
              else if (entry.rewardClaimed)
                const Text('Recompensa reclamada', style: AppTextStyles.caption)
              else
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final userId =
                        ref.read(authControllerProvider).user?.id ?? '';
                    final claimed = await runGuarded(
                      () => ref
                          .read(achievementRepositoryProvider)
                          .claimReward(
                            userId: userId,
                            achievementId: entry.id,
                          ),
                      progress: 'Reclamando recompensa...',
                    );
                    if (claimed) ref.invalidate(achievementsProvider);
                  },
                  child: const Text('RECLAMAR RECOMPENSA'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content(AchievementCollection collection) {
    final completed =
        collection.entries.where((entry) => entry.isComplete).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PixelPanel(
          title: 'Logros desbloqueados',
          accent: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${collection.unlockedTotal} / ${collection.total}',
                style: AppTextStyles.title,
              ),
              const SizedBox(height: 10),
              PixelProgressBar(
                value: collection.total == 0
                    ? 0
                    : collection.unlockedTotal / collection.total,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (collection.entries.isEmpty)
          const PixelPanel(
            title: 'Sin logros',
            child: Text(
              'Completa misiones y explora para registrar tus logros.',
              style: AppTextStyles.body,
            ),
          )
        else
          for (final entry in collection.entries) ...[
            PixelTile(
              title: entry.name,
              subtitle: entry.isComplete
                  ? 'Completado · ${formatDate(entry.completedAt!)}'
                  : '${entry.progress} / ${entry.target}',
              leading: Icon(
                entry.isComplete ? Icons.military_tech : Icons.lock_outline,
                color: entry.isComplete
                    ? AppColors.primaryLight
                    : AppColors.textSecondary,
              ),
              trailing: Text(
                entry.rewardClaimed ? 'LISTO' : '›',
                style: AppTextStyles.label.copyWith(
                  color: entry.rewardClaimed
                      ? AppColors.textSecondary
                      : AppColors.primaryLight,
                ),
              ),
              bottom: entry.isComplete
                  ? null
                  : PixelProgressBar(
                      value: entry.progress / entry.target,
                      segments: 10,
                    ),
              onTap: () => _openAchievement(entry),
            ),
            const SizedBox(height: 10),
          ],
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.push(AppRoutes.progress),
          child: const Text('VER PROGRESO DE PARTIDA'),
        ),
        Text(
          '$completed logros completados en esta lista',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final achievements = ref.watch(achievementsProvider);
    return ScreenScaffold(
      centered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PixelHeader(
            title: 'Logros',
            onBack: () => context.backOr(AppRoutes.home),
          ),
          const SizedBox(height: 18),
          AsyncValueView<AchievementCollection>(
            value: achievements,
            loadingMessage: 'Consultando logros...',
            onRetry: () => ref.invalidate(achievementsProvider),
            data: _content,
          ),
          if (status.isNotEmpty) ...[
            const SizedBox(height: 14),
            StatusConsole(message: status, isError: statusIsError),
          ],
        ],
      ),
    );
  }
}
