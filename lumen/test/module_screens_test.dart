import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Imports relativos a propósito: funcionan sin conocer el nombre del paquete.
// ignore_for_file: avoid_relative_lib_imports
import '../lib/features/codex/models/codex_entry.dart';
import '../lib/features/codex/providers/codex_providers.dart';
import '../lib/features/codex/screens/codex_screen.dart';
import '../lib/features/inventory/models/inventory_item.dart';
import '../lib/features/inventory/providers/inventory_providers.dart';
import '../lib/features/inventory/screens/inventory_screen.dart';
import '../lib/features/leaderboard/models/leaderboard_entry.dart';
import '../lib/features/leaderboard/providers/leaderboard_providers.dart';
import '../lib/features/leaderboard/screens/leaderboard_screen.dart';
import '../lib/features/missions/models/quest.dart';
import '../lib/features/missions/providers/quest_providers.dart';
import '../lib/features/missions/screens/missions_screen.dart';

void main() {
  testWidgets('el inventario lista objetos y permite inspeccionarlos', (
    tester,
  ) async {
    const item = InventoryItem(
      id: 'wrench-x3',
      name: 'Llave de ajuste X-3',
      type: ItemType.weapon,
      description: 'Herramienta de mantenimiento.',
      quantity: 1,
      stats: [ItemStat('Daño', '45')],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          inventoryProvider.overrideWith((ref) async => [item]),
        ],
        child: const MaterialApp(home: InventoryScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Llave de ajuste X-3'), findsOneWidget);
    await tester.tap(find.text('Llave de ajuste X-3'));
    await tester.pumpAndSettle();
    expect(find.text('Herramienta de mantenimiento.'), findsOneWidget);
    expect(find.text('45'), findsOneWidget);
  });

  testWidgets('las misiones separan activas y completadas', (tester) async {
    const quests = [
      Quest(
        id: 'active',
        title: 'Reactivar generador',
        progress: 1,
        target: 3,
        location: 'Fábrica hundida',
        reward: '50 chatarra',
      ),
      Quest(
        id: 'complete',
        title: 'Recuperar planos',
        progress: 2,
        target: 2,
        location: 'Taller',
        reward: 'Plano',
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [questsProvider.overrideWith((ref) async => quests)],
        child: const MaterialApp(home: MissionsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reactivar generador'), findsOneWidget);
    expect(find.text('Recuperar planos'), findsNothing);
    await tester.tap(find.text('COMPLETADAS (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Recuperar planos'), findsOneWidget);
    expect(find.text('RECLAMAR RECOMPENSA'), findsOneWidget);
  });

  testWidgets('el códex muestra personajes desbloqueados y cifrados', (
    tester,
  ) async {
    const entries = [
      CodexEntry(
        id: 'm4',
        name: 'M-4',
        avatarId: 'm4',
        description: 'Unidad principal.',
        isUnlocked: true,
      ),
      CodexEntry(
        id: 'unknown',
        name: 'Registro cifrado',
        description: '',
        isUnlocked: false,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          codexCharactersProvider.overrideWith((ref) async => entries),
        ],
        child: const MaterialApp(home: CodexScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('M-4'), findsOneWidget);
    expect(find.text('???'), findsOneWidget);
    expect(find.text('1 de 2 registros'), findsOneWidget);
  });

  testWidgets('el ránking muestra la posición del jugador y los filtros', (
    tester,
  ) async {
    const snapshot = LeaderboardSnapshot(
      entries: [
        LeaderboardEntry(
          rank: 1,
          name: 'LEGEND_SLAYER',
          score: 1500000,
          avatarId: 'm4',
        ),
      ],
      playerRank: 215,
      playerScore: 350000,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          leaderboardProvider(LeaderboardScope.global)
              .overrideWith((ref) async => snapshot),
        ],
        child: const MaterialApp(home: LeaderboardScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('LEGEND_SLAYER'), findsOneWidget);
    expect(find.text('#215'), findsOneWidget);
    expect(find.text('AMIGOS'), findsOneWidget);
    expect(find.text('SEMANAL'), findsOneWidget);
  });
}
