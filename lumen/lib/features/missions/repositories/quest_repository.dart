import '../models/quest.dart';

abstract interface class QuestRepository {
  Future<List<Quest>> fetchQuests({required String userId});

  Future<void> claimReward({required String userId, required String questId});
}
