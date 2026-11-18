class AchievementEntry {
  const AchievementEntry({
    required this.id,
    required this.name,
    required this.description,
    required this.progress,
    required this.target,
    required this.reward,
    this.completedAt,
    this.rewardClaimed = false,
  });

  final String id;
  final String name;
  final String description;
  final int progress;
  final int target;
  final String reward;
  final DateTime? completedAt;
  final bool rewardClaimed;

  bool get isComplete => completedAt != null || progress >= target;

  AchievementEntry copyWith({bool? rewardClaimed}) => AchievementEntry(
        id: id,
        name: name,
        description: description,
        progress: progress,
        target: target,
        reward: reward,
        completedAt: completedAt,
        rewardClaimed: rewardClaimed ?? this.rewardClaimed,
      );
}

class AchievementCollection {
  const AchievementCollection({
    required this.unlockedTotal,
    required this.total,
    required this.entries,
  });

  const AchievementCollection.empty()
      : unlockedTotal = 0,
        total = 24,
        entries = const [];

  final int unlockedTotal;
  final int total;
  final List<AchievementEntry> entries;

  AchievementCollection copyWith({List<AchievementEntry>? entries}) =>
      AchievementCollection(
        unlockedTotal: unlockedTotal,
        total: total,
        entries: entries ?? this.entries,
      );
}
