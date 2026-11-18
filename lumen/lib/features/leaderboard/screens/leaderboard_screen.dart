import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/pixel_header.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/pixel_segmented_control.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/state_views.dart';
import '../../auth/providers/auth_providers.dart';
import '../../player/widgets/robot_avatar.dart';
import '../models/leaderboard_entry.dart';
import '../providers/leaderboard_providers.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  LeaderboardScope _scope = LeaderboardScope.global;

  @override
  Widget build(BuildContext context) {
    final ranking = ref.watch(leaderboardProvider(_scope));
    final playerName = ref.watch(
      authControllerProvider.select((state) => state.user?.displayName),
    );

    return ScreenScaffold(
      centered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PixelHeader(title: 'Ránking'),
          const SizedBox(height: 16),
          PixelSegmentedControl(
            labels: const ['Global', 'Amigos', 'Semanal'],
            selectedIndex: _scope.index,
            onSelected: (index) {
              setState(() => _scope = LeaderboardScope.values[index]);
            },
          ),
          const SizedBox(height: 16),
          AsyncValueView<LeaderboardSnapshot>(
            value: ranking,
            loadingMessage: 'Consultando clasificación...',
            onRetry: () => ref.invalidate(leaderboardProvider(_scope)),
            data: (snapshot) => snapshot.entries.isEmpty
                ? const EmptyState(
                    title: 'Clasificación no disponible',
                    message:
                        'El ránking aparecerá cuando sincronices una '
                        'partida con tu cuenta.',
                  )
                : _RankingContent(
                    snapshot: snapshot,
                    scope: _scope,
                    playerName: playerName ?? 'Operador',
                  ),
          ),
        ],
      ),
    );
  }
}

class _RankingContent extends StatelessWidget {
  const _RankingContent({
    required this.snapshot,
    required this.scope,
    required this.playerName,
  });

  final LeaderboardSnapshot snapshot;
  final LeaderboardScope scope;
  final String playerName;

  @override
  Widget build(BuildContext context) {
    final entries = snapshot.entries;
    final topEntries = entries.take(3);
    final remainingEntries = entries.skip(3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'MEJORES OPERADORES · ${scope.label.toUpperCase()}',
          style: AppTextStyles.label,
        ),
        const SizedBox(height: 10),
        for (final entry in topEntries) ...[
          _LeaderboardRow(entry: entry),
          const SizedBox(height: 8),
        ],
        _PlayerRankCard(
          rank: snapshot.playerRank,
          score: snapshot.playerScore,
          name: playerName,
        ),
        const SizedBox(height: 8),
        for (final entry in remainingEntries) ...[
          _LeaderboardRow(entry: entry),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry});

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${entry.rank}',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading.copyWith(
                color: entry.rank <= 3
                    ? AppColors.primaryLight
                    : AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              border: Border.all(color: AppColors.metal, width: 2),
            ),
            child: RobotAvatar(avatarId: entry.avatarId, pixel: 2.7),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              entry.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('PUNTAJE', style: AppTextStyles.label),
              Text(
                formatScore(entry.score),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerRankCard extends StatelessWidget {
  const _PlayerRankCard({
    required this.rank,
    required this.score,
    required this.name,
  });

  final int rank;
  final int score;
  final String name;

  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      title: 'Tu posición',
      accent: true,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Text(
            '#$rank',
            style: AppTextStyles.heading.copyWith(
              color: AppColors.primaryLight,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              border: Border.all(color: AppColors.primaryLight, width: 2),
            ),
            child: const RobotAvatar(
              avatarId: RobotAvatars.defaultId,
              pixel: 2.7,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatScore(score),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primaryLight,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

String formatScore(int score) {
  final digits = score.toString();
  final groups = <String>[];
  for (var end = digits.length; end > 0; end -= 3) {
    final start = end - 3 < 0 ? 0 : end - 3;
    groups.insert(0, digits.substring(start, end));
  }
  return groups.join(',');
}
