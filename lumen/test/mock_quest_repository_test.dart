import 'package:flutter_test/flutter_test.dart';

// Imports relativos a propósito: funcionan sin conocer el nombre del paquete.
// ignore_for_file: avoid_relative_lib_imports
import '../lib/core/errors/app_failure.dart';
import '../lib/core/mock/mock_data.dart';
import '../lib/features/missions/repositories/mock_quest_repository.dart';

void main() {
  late MockQuestRepository repo;

  setUp(() => repo = MockQuestRepository(latency: Duration.zero));

  test('la demo trae misiones activas y una recompensa disponible', () async {
    final quests = await repo.fetchQuests(userId: MockData.demoUserId);
    expect(quests.where((quest) => !quest.isComplete), hasLength(4));
    expect(
      quests.where((quest) => quest.isComplete && !quest.rewardClaimed),
      hasLength(1),
    );
  });

  test(
    'reclamar la recompensa actualiza el estado y evita duplicados',
    () async {
      await repo.claimReward(
        userId: MockData.demoUserId,
        questId: 'reactivate-terminal',
      );
      final quests = await repo.fetchQuests(userId: MockData.demoUserId);
      final quest = quests.firstWhere(
        (item) => item.id == 'reactivate-terminal',
      );
      expect(quest.rewardClaimed, isTrue);
      await expectLater(
        repo.claimReward(
          userId: MockData.demoUserId,
          questId: 'reactivate-terminal',
        ),
        throwsA(isA<UnknownFailure>()),
      );
    },
  );

  test('una cuenta nueva no tiene misiones', () async {
    expect(await repo.fetchQuests(userId: 'usr_nueva'), isEmpty);
  });
}
