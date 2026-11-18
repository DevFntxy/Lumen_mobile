import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../models/quest.dart';
import '../repositories/mock_quest_repository.dart';
import '../repositories/quest_repository.dart';

final questRepositoryProvider = Provider<QuestRepository>(
  (ref) => MockQuestRepository(),
);

final questsProvider = FutureProvider<List<Quest>>((ref) async {
  final userId = ref.watch(authControllerProvider.select((s) => s.user?.id));
  if (userId == null) return const [];
  return ref.watch(questRepositoryProvider).fetchQuests(userId: userId);
});
