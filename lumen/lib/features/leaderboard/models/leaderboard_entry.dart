enum LeaderboardScope {
  global('Global'),
  friends('Amigos'),
  weekly('Semanal');

  const LeaderboardScope(this.label);

  final String label;
}

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.score,
    required this.avatarId,
  });

  final int rank;
  final String name;
  final int score;
  final String avatarId;
}

class LeaderboardSnapshot {
  const LeaderboardSnapshot({
    required this.entries,
    required this.playerRank,
    required this.playerScore,
  });

  final List<LeaderboardEntry> entries;
  final int playerRank;
  final int playerScore;
}
