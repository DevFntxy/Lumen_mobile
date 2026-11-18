import 'package:flutter_test/flutter_test.dart';

// Imports relativos a propósito: funcionan sin conocer el nombre del paquete.
// ignore_for_file: avoid_relative_lib_imports
import '../lib/core/mock/mock_data.dart';
import '../lib/features/inventory/repositories/mock_inventory_repository.dart';

void main() {
  late MockInventoryRepository repo;

  setUp(() => repo = MockInventoryRepository(latency: Duration.zero));

  test('la cuenta demo tiene ítems con ids únicos', () async {
    final items = await repo.fetchItems(userId: MockData.demoUserId);
    expect(items, isNotEmpty);
    expect(items.map((item) => item.id).toSet().length, items.length);
  });

  test('una cuenta nueva tiene el inventario vacío', () async {
    expect(await repo.fetchItems(userId: 'usr_nueva'), isEmpty);
  });

  test('la proporción de pila solo existe si hay capacidad', () async {
    final items = await repo.fetchItems(userId: MockData.demoUserId);
    final cells = items.firstWhere((item) => item.id == 'energy-cell');
    expect(cells.fill, closeTo(0.8, 0.0001));
    final wrench = items.firstWhere((item) => item.id == 'wrench-x3');
    expect(wrench.fill, isNull);
  });

  test('el resumen muestra cantidades acumulables y estadísticas', () async {
    final items = await repo.fetchItems(userId: MockData.demoUserId);
    final cells = items.firstWhere((item) => item.id == 'energy-cell');
    expect(cells.summary, contains('Cant. 8 de 10'));
    expect(cells.summary, contains('Recupera 200'));
  });
}
