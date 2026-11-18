class Quest {
  const Quest({
    required this.id,
    required this.title,
    required this.progress,
    required this.target,
    required this.location,
    required this.reward,
    this.rewardClaimed = false,
  });

  final String id;
  final String title;
  final int progress;
  final int target;
  final String location;
  final String reward;
  final bool rewardClaimed;

  bool get isComplete => progress >= target;

  double get completion {
    if (target <= 0) return 0;
    return (progress / target).clamp(0.0, 1.0).toDouble();
  }

  Quest copyWith({bool? rewardClaimed}) => Quest(
    id: id,
    title: title,
    progress: progress,
    target: target,
    location: location,
    reward: reward,
    rewardClaimed: rewardClaimed ?? this.rewardClaimed,
  );
}
