import 'package:flutter_test/flutter_test.dart';

// ignore_for_file: avoid_relative_lib_imports
import '../lib/core/errors/app_failure.dart';
import '../lib/core/mock/mock_data.dart';
import '../lib/features/achievements/repositories/mock_achievement_repository.dart';

void main() {
  test(
    'el demo permite reclamar una recompensa completada solo una vez',
    () async {
      final repository = MockAchievementRepository(latency: Duration.zero);

      final claimed = await repository.claimReward(
        userId: MockData.demoUserId,
        achievementId: 'city-explorer-1',
      );
      expect(
        claimed.entries
            .firstWhere((entry) => entry.id == 'city-explorer-1')
            .rewardClaimed,
        isTrue,
      );
      await expectLater(
        repository.claimReward(
          userId: MockData.demoUserId,
          achievementId: 'city-explorer-1',
        ),
        throwsA(isA<RuleFailure>()),
      );
    },
  );

  test('no permite reclamar un logro incompleto', () async {
    final repository = MockAchievementRepository(latency: Duration.zero);

    await expectLater(
      repository.claimReward(
        userId: MockData.demoUserId,
        achievementId: 'secret-agent',
      ),
      throwsA(isA<RuleFailure>()),
    );
  });
}
