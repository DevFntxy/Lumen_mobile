import 'package:flutter_test/flutter_test.dart';

// Imports relativos a propósito: funcionan sin conocer el nombre del paquete.
// ignore_for_file: avoid_relative_lib_imports
import '../lib/core/mock/mock_data.dart';
import '../lib/features/leaderboard/models/leaderboard_entry.dart';
import '../lib/features/leaderboard/repositories/mock_leaderboard_repository.dart';

void main() {
  late MockLeaderboardRepository repo;

  setUp(() => repo = MockLeaderboardRepository(latency: Duration.zero));

  test('la clasificación muestra puntajes de mayor a menor', () async {
    final ranking = await repo.fetchLeaderboard(
      userId: MockData.demoUserId,
      scope: LeaderboardScope.global,
    );
    expect(ranking.entries, hasLength(5));
    expect(
      ranking.entries.first.score,
      greaterThan(ranking.entries.last.score),
    );
    expect(ranking.playerRank, 215);
  });

  test(
    'los filtros de amigos y semanal muestran clasificaciones distintas',
    () async {
      final friends = await repo.fetchLeaderboard(
        userId: MockData.demoUserId,
        scope: LeaderboardScope.friends,
      );
      final weekly = await repo.fetchLeaderboard(
        userId: MockData.demoUserId,
        scope: LeaderboardScope.weekly,
      );
      expect(friends.playerRank, 5);
      expect(weekly.playerRank, 12);
    },
  );

  test('una cuenta nueva no tiene datos en el ránking', () async {
    final ranking = await repo.fetchLeaderboard(
      userId: 'usr_nueva',
      scope: LeaderboardScope.global,
    );
    expect(ranking.entries, isEmpty);
    expect(ranking.playerRank, 0);
  });
}
