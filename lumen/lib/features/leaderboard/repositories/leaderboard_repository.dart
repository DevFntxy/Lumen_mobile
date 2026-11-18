import '../models/leaderboard_entry.dart';

abstract interface class LeaderboardRepository {
  Future<LeaderboardSnapshot> fetchLeaderboard({
    required String userId,
    required LeaderboardScope scope,
  });
}
