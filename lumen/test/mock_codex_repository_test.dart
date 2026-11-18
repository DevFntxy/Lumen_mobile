import 'package:flutter_test/flutter_test.dart';

// Imports relativos a propósito: funcionan sin conocer el nombre del paquete.
// ignore_for_file: avoid_relative_lib_imports
import '../lib/core/mock/mock_data.dart';
import '../lib/features/codex/repositories/mock_codex_repository.dart';

void main() {
  late MockCodexRepository repo;

  setUp(() => repo = MockCodexRepository(latency: Duration.zero));

  test(
    'el códex demo mantiene el total y los registros identificados',
    () async {
      final entries = await repo.fetchCharacters(userId: MockData.demoUserId);
      expect(entries, hasLength(12));
      expect(entries.where((entry) => entry.isUnlocked), hasLength(5));
    },
  );

  test('una cuenta nueva no tiene registros de códex', () async {
    expect(await repo.fetchCharacters(userId: 'usr_nueva'), isEmpty);
  });
}
