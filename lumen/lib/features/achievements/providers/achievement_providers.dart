import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../models/achievement_collection.dart';
import '../repositories/achievement_repository.dart';
import '../repositories/mock_achievement_repository.dart';

final achievementRepositoryProvider = Provider<AchievementRepository>(
  (ref) => MockAchievementRepository(),
);

final achievementsProvider = FutureProvider<AchievementCollection>((ref) async {
  final userId = ref.watch(authControllerProvider.select((s) => s.user?.id));
  if (userId == null) return const AchievementCollection.empty();
  return ref
      .watch(achievementRepositoryProvider)
      .fetchAchievements(userId: userId);
});
