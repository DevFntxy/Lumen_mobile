import '../models/achievement_collection.dart';

abstract interface class AchievementRepository {
  Future<AchievementCollection> fetchAchievements({required String userId});

  Future<AchievementCollection> claimReward({
    required String userId,
    required String achievementId,
  });
}
