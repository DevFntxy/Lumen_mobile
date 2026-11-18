import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/async_form_mixin.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/pixel_button.dart';
import '../../../core/widgets/pixel_header.dart';
import '../../../core/widgets/pixel_nav_card.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/pixel_progress_bar.dart';
import '../../../core/widgets/pixel_segmented_control.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/status_console.dart';
import '../../auth/providers/auth_providers.dart';
import '../models/quest.dart';
import '../providers/quest_providers.dart';

class MissionsScreen extends ConsumerStatefulWidget {
  const MissionsScreen({super.key});

  @override
  ConsumerState<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends ConsumerState<MissionsScreen>
    with AsyncFormMixin<MissionsScreen> {
  int _selectedFilter = 0;

  Future<void> _claimReward(Quest quest) async {
    final userId = ref.read(authControllerProvider).user?.id;
    if (userId == null) {
      setStatus('Inicia sesión para reclamar la recompensa.', error: true);
      return;
    }

    final claimed = await runGuarded(() async {
      await ref
          .read(questRepositoryProvider)
          .claimReward(userId: userId, questId: quest.id);
      ref.invalidate(questsProvider);
    }, progress: 'Reclamando recompensa...');
    if (claimed) setStatus('Recompensa reclamada: ${quest.reward}.');
  }

  Widget _content(List<Quest> quests) {
    final active = quests.where((quest) => !quest.isComplete).toList();
    final completed = quests.where((quest) => quest.isComplete).toList();
    final visible = _selectedFilter == 0 ? active : completed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PixelPanel(
          title: 'Bitácora de directivas',
          accent: true,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${active.length} misiones activas',
                  style: AppTextStyles.body,
                ),
              ),
              Text(
                '${completed.where((quest) => !quest.rewardClaimed).length} '
                'por reclamar',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primaryLight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PixelSegmentedControl(
          labels: [
            'Activas (${active.length})',
            'Completadas (${completed.length})',
          ],
          selectedIndex: _selectedFilter,
          onSelected: (index) => setState(() => _selectedFilter = index),
        ),
        const SizedBox(height: 12),
        if (visible.isEmpty)
          EmptyState(
            title: _selectedFilter == 0
                ? 'Sin misiones activas'
                : 'Sin misiones completadas',
            message: _selectedFilter == 0
                ? 'Las nuevas directivas aparecerán aquí al sincronizar tu partida.'
                : 'Cuando completes una directiva, aparecerá en esta sección.',
          )
        else
          for (final quest in visible) ...[
            _QuestCard(
              quest: quest,
              busy: busy,
              onClaim: () => _claimReward(quest),
            ),
            const SizedBox(height: 10),
          ],
        const SizedBox(height: 12),
        PixelNavCard(
          title: 'Progreso de partida',
          subtitle: 'Consulta el avance global de la campaña',
          onTap: () => context.push(AppRoutes.progress),
        ),
        const SizedBox(height: 12),
        PixelNavCard(
          title: 'Mapa de zonas',
          subtitle: 'Explora los sectores y sus objetivos',
          onTap: () => context.push(AppRoutes.zoneMap),
        ),
        if (status.isNotEmpty) ...[
          const SizedBox(height: 16),
          StatusConsole(message: status, isError: statusIsError),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final quests = ref.watch(questsProvider);

    return ScreenScaffold(
      centered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PixelHeader(title: 'Misiones'),
          const SizedBox(height: 20),
          AsyncValueView<List<Quest>>(
            value: quests,
            loadingMessage: 'Cargando directivas...',
            onRetry: () => ref.invalidate(questsProvider),
            data: _content,
          ),
        ],
      ),
    );
  }
}

class _QuestCard extends StatelessWidget {
  const _QuestCard({
    required this.quest,
    required this.busy,
    required this.onClaim,
  });

  final Quest quest;
  final bool busy;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('> ', style: AppTextStyles.heading),
              Expanded(child: Text(quest.title, style: AppTextStyles.heading)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(
                child: Text('PROGRESO', style: AppTextStyles.label),
              ),
              Text(
                '${quest.progress} / ${quest.target}',
                style: AppTextStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: 6),
          PixelProgressBar(value: quest.completion, segments: 10),
          const SizedBox(height: 8),
          Text('Sector: ${quest.location}', style: AppTextStyles.caption),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recompensa: ${quest.reward}',
                  style: AppTextStyles.caption,
                ),
              ),
              if (!quest.isComplete)
                Text('EN CURSO', style: AppTextStyles.label)
              else if (quest.rewardClaimed)
                Text(
                  'RECLAMADA',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
          if (quest.isComplete && !quest.rewardClaimed) ...[
            const SizedBox(height: 10),
            PixelButton(
              label: 'Reclamar recompensa',
              compact: true,
              onPressed: busy ? null : onClaim,
              isLoading: busy,
            ),
          ],
        ],
      ),
    );
  }
}
