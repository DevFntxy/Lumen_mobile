import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../models/leaderboard_entry.dart';
import '../repositories/leaderboard_repository.dart';
import '../repositories/mock_leaderboard_repository.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>(
  (ref) => MockLeaderboardRepository(),
);

final leaderboardProvider =
    FutureProvider.family<LeaderboardSnapshot, LeaderboardScope>((
      ref,
      scope,
    ) async {
      final userId = ref.watch(
        authControllerProvider.select((s) => s.user?.id),
      );
      if (userId == null) {
        return const LeaderboardSnapshot(
          entries: [],
          playerRank: 0,
          playerScore: 0,
        );
      }
      return ref
          .watch(leaderboardRepositoryProvider)
          .fetchLeaderboard(userId: userId, scope: scope);
    });
