import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Imports relativos a propósito: funcionan sin conocer el nombre del paquete.
// ignore_for_file: avoid_relative_lib_imports
import '../lib/features/player/models/player_progress.dart';
import '../lib/features/player/providers/player_providers.dart';
import '../lib/features/player/screens/progress_screen.dart';

void main() {
  final progress = PlayerProgress(
    actName: 'Acto II: Fábrica hundida',
    actProgress: 0.65,
    overallCompletion: 0.38,
    lastSession: DateTime(2026, 10, 30, 18, 42),
    zonesUnlocked: 2,
    zonesTotal: 5,
    activeQuests: 4,
    codexUnlocked: 5,
    codexTotal: 12,
    achievementsUnlocked: 7,
    achievementsTotal: 24,
  );

  testWidgets('muestra las métricas y destinos del progreso', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          playerProgressProvider.overrideWith((ref) async => progress),
        ],
        child: const MaterialApp(home: ProgressScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Acto II: Fábrica hundida'), findsOneWidget);
    expect(find.text('38%'), findsOneWidget);
    expect(find.text('2 / 5'), findsOneWidget);
    expect(find.text('5 / 12'), findsOneWidget);
    expect(find.text('7 / 24'), findsOneWidget);
    expect(find.text('Mapa de zonas'), findsOneWidget);
    expect(find.text('Tabla de clasificación'), findsOneWidget);
    expect(find.text('Logros'), findsOneWidget);
  });

  testWidgets('muestra un estado vacío cuando no hay partida', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [playerProgressProvider.overrideWith((ref) async => null)],
        child: const MaterialApp(home: ProgressScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('SIN PROGRESO SINCRONIZADO'), findsOneWidget);
    expect(find.text('Mapa de zonas'), findsNothing);
  });
}
