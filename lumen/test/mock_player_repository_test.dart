import 'package:flutter_test/flutter_test.dart';

// Imports relativos a propósito: funcionan sin conocer el nombre del paquete.
// ignore_for_file: avoid_relative_lib_imports
import '../lib/core/mock/mock_data.dart';
import '../lib/features/player/repositories/mock_player_repository.dart';

void main() {
  late MockPlayerRepository repo;

  setUp(() => repo = MockPlayerRepository(latency: Duration.zero));

  test('la cuenta demo tiene progreso', () async {
    final progress = await repo.fetchProgress(userId: MockData.demoUserId);
    expect(progress, isNotNull);
    expect(progress!.actName, MockData.demoActName);
    expect(progress.codexUnlocked <= progress.codexTotal, isTrue);
  });

  test('una cuenta nueva no tiene progreso (estado vacío)', () async {
    expect(await repo.fetchProgress(userId: 'usr_nueva'), isNull);
  });

  test('el perfil demo trae cuentas vinculadas; el de una cuenta nueva, ninguna',
      () async {
    final demo = await repo.fetchProfile(userId: MockData.demoUserId);
    expect(demo.linkedProviders.where((p) => p.isLinked), isNotEmpty);

    final fresh = await repo.fetchProfile(userId: 'usr_nueva');
    expect(fresh.linkedProviders.where((p) => p.isLinked), isEmpty);
  });

  test('el avatar elegido se conserva al volver a pedir el perfil', () async {
    await repo.updateAvatar(userId: MockData.demoUserId, avatarId: 'a7');
    final profile = await repo.fetchProfile(userId: MockData.demoUserId);
    expect(profile.avatarId, 'a7');
  });
}
