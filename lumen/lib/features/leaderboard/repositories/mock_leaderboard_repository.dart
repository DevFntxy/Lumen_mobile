import '../../../app/config/app_config.dart';
import '../../../core/mock/mock_data.dart';
import '../models/leaderboard_entry.dart';
import 'leaderboard_repository.dart';

class MockLeaderboardRepository implements LeaderboardRepository {
  MockLeaderboardRepository({Duration? latency})
    : _latency = latency ?? AppConfig.mockLatency;

  final Duration _latency;

  static const Map<LeaderboardScope, LeaderboardSnapshot> _demoRankings = {
    LeaderboardScope.global: LeaderboardSnapshot(
      entries: [
        LeaderboardEntry(
          rank: 1,
          name: 'LEGEND_SLAYER',
          score: 1500000,
          avatarId: 'm4',
        ),
        LeaderboardEntry(
          rank: 2,
          name: 'STORM_KING',
          score: 1200000,
          avatarId: 'sentinel',
        ),
        LeaderboardEntry(
          rank: 3,
          name: 'VALOR_BRINGER',
          score: 900000,
          avatarId: 'a7',
        ),
        LeaderboardEntry(
          rank: 4,
          name: 'CELESTIAL_MAGE',
          score: 850000,
          avatarId: 'scavenger',
        ),
        LeaderboardEntry(
          rank: 5,
          name: 'RUNE_WARRIOR',
          score: 720000,
          avatarId: 'sentinel',
        ),
      ],
      playerRank: 215,
      playerScore: 350000,
    ),
    LeaderboardScope.friends: LeaderboardSnapshot(
      entries: [
        LeaderboardEntry(
          rank: 1,
          name: 'STORM_KING',
          score: 1200000,
          avatarId: 'sentinel',
        ),
        LeaderboardEntry(
          rank: 2,
          name: 'VALOR_BRINGER',
          score: 900000,
          avatarId: 'a7',
        ),
        LeaderboardEntry(
          rank: 3,
          name: 'CELESTIAL_MAGE',
          score: 850000,
          avatarId: 'scavenger',
        ),
        LeaderboardEntry(
          rank: 4,
          name: 'RUNE_WARRIOR',
          score: 720000,
          avatarId: 'm4',
        ),
      ],
      playerRank: 5,
      playerScore: 350000,
    ),
    LeaderboardScope.weekly: LeaderboardSnapshot(
      entries: [
        LeaderboardEntry(
          rank: 1,
          name: 'STORM_KING',
          score: 320000,
          avatarId: 'sentinel',
        ),
        LeaderboardEntry(
          rank: 2,
          name: 'LEGEND_SLAYER',
          score: 280000,
          avatarId: 'm4',
        ),
        LeaderboardEntry(
          rank: 3,
          name: 'RUNE_WARRIOR',
          score: 210000,
          avatarId: 'a7',
        ),
        LeaderboardEntry(
          rank: 4,
          name: 'CELESTIAL_MAGE',
          score: 170000,
          avatarId: 'scavenger',
        ),
        LeaderboardEntry(
          rank: 5,
          name: 'VALOR_BRINGER',
          score: 150000,
          avatarId: 'sentinel',
        ),
      ],
      playerRank: 12,
      playerScore: 85000,
    ),
  };

  @override
  Future<LeaderboardSnapshot> fetchLeaderboard({
    required String userId,
    required LeaderboardScope scope,
  }) async {
    await Future<void>.delayed(_latency);
    if (userId != MockData.demoUserId) {
      return const LeaderboardSnapshot(
        entries: [],
        playerRank: 0,
        playerScore: 0,
      );
    }
    return _demoRankings[scope]!;
  }
}
