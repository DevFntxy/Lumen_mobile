import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore_for_file: avoid_relative_lib_imports
import '../lib/features/about/screens/about_software_screen.dart';
import '../lib/features/about/screens/about_team_screen.dart';
import '../lib/features/achievements/models/achievement_collection.dart';
import '../lib/features/achievements/providers/achievement_providers.dart';
import '../lib/features/achievements/screens/achievements_screen.dart';
import '../lib/features/codex/models/threat_entry.dart';
import '../lib/features/codex/providers/threat_providers.dart';
import '../lib/features/codex/screens/threat_codex_screen.dart';
import '../lib/features/map/screens/zone_map_screen.dart';
import '../lib/features/memories/models/memory_fragment.dart';
import '../lib/features/memories/providers/memory_providers.dart';
import '../lib/features/memories/screens/memory_fragments_screen.dart';
import '../lib/features/player/models/player_progress.dart';
import '../lib/features/player/providers/player_providers.dart';
import '../lib/features/settings/providers/settings_providers.dart';
import '../lib/features/settings/repositories/mock_settings_repository.dart';
import '../lib/features/settings/screens/settings_screen.dart';
import '../lib/features/skills/models/skill_tree.dart';
import '../lib/features/skills/providers/skills_providers.dart';
import '../lib/features/skills/screens/skills_screen.dart';

void main() {
  testWidgets('Ajustes aplica el cambio de CRT', (tester) async {
    final container = ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWith(
          (ref) => MockSettingsRepository(latency: Duration.zero),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Efecto CRT'));
    await tester.pumpAndSettle();

    expect(container.read(settingsControllerProvider).crtEnabled, isFalse);
  });

  testWidgets('Habilidades muestra el árbol y los puntos disponibles', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          skillsControllerProvider.overrideWith(_TestSkillsController.new),
        ],
        child: const MaterialApp(home: SkillsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Puntos disponibles'), findsOneWidget);
    expect(find.text('Impacto preciso'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
  });

  testWidgets('Códex de amenazas filtra enemigos y jefes', (tester) async {
    const threats = [
      ThreatEntry(
        id: 'enemy',
        name: 'Dron de vigilancia',
        description: 'Unidad de patrulla.',
        kind: ThreatKind.enemy,
        avatarId: 'sentinel',
        isIdentified: true,
      ),
      ThreatEntry(
        id: 'boss',
        name: 'El Jardinero',
        description: 'Jefe de zona.',
        kind: ThreatKind.boss,
        avatarId: 'scavenger',
        isIdentified: true,
      ),
    ];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [threatsProvider.overrideWith((ref) async => threats)],
        child: const MaterialApp(home: ThreatCodexScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dron de vigilancia'), findsOneWidget);
    expect(find.text('El Jardinero'), findsNothing);
    await tester.tap(find.text('JEFES'));
    await tester.pumpAndSettle();
    expect(find.text('El Jardinero'), findsOneWidget);
  });

  testWidgets('Logros representa progreso y recompensa', (tester) async {
    final collection = AchievementCollection(
      unlockedTotal: 1,
      total: 24,
      entries: [
        AchievementEntry(
          id: 'done',
          name: 'Primera misión',
          description: 'Completa una misión.',
          progress: 1,
          target: 1,
          reward: '100 XP',
          completedAt: DateTime(2024, 10, 10),
        ),
        const AchievementEntry(
          id: 'incomplete',
          name: 'Agente secreto',
          description: 'Encuentra registros ocultos.',
          progress: 1,
          target: 10,
          reward: 'Marco',
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          achievementsProvider.overrideWith((ref) async => collection),
        ],
        child: const MaterialApp(home: AchievementsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Primera misión'), findsOneWidget);
    expect(find.text('Agente secreto'), findsOneWidget);
    await tester.tap(find.text('Primera misión'));
    await tester.pumpAndSettle();
    expect(find.text('RECLAMAR RECOMPENSA'), findsOneWidget);
  });

  testWidgets('Fragmentos bloqueados no revelan su contenido', (tester) async {
    const fragments = [
      MemoryFragment(
        id: 'locked',
        title: 'Mensaje oculto',
        sector: MemorySector.foundry,
        summary: 'Resumen secreto',
        transcript: 'Texto reservado',
        isUnlocked: false,
      ),
    ];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          memoryFragmentsProvider.overrideWith((ref) async => fragments),
        ],
        child: const MaterialApp(home: MemoryFragmentsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('???'), findsOneWidget);
    await tester.tap(find.text('???'));
    await tester.pumpAndSettle();
    expect(find.text('Fragmento cifrado'), findsOneWidget);
    expect(find.text('Mensaje oculto'), findsNothing);
    expect(find.text('Texto reservado'), findsNothing);
  });

  testWidgets('Mapa dibuja las zonas del progreso del jugador', (tester) async {
    final progress = PlayerProgress(
      actName: 'Acto I',
      actProgress: 0.4,
      overallCompletion: 0.2,
      lastSession: DateTime(2024, 10, 10),
      zonesUnlocked: 2,
      zonesTotal: 5,
      activeQuests: 2,
      codexUnlocked: 4,
      codexTotal: 12,
      achievementsUnlocked: 7,
      achievementsTotal: 24,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          playerProgressProvider.overrideWith((ref) async => progress),
        ],
        child: const MaterialApp(home: ZoneMapScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sector G'), findsOneWidget);
    expect(find.text('Dársena 04'), findsOneWidget);
    expect(find.text('Núcleo central'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Acerca de muestra ficha y créditos del equipo', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutSoftwareScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Ficha técnica'), findsOneWidget);
    expect(find.text('Flutter (Dart)'), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: AboutTeamScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Equipo de desarrollo: DIMATREK'), findsOneWidget);
    expect(find.text('Derek Sesni'), findsOneWidget);
  });
}

class _TestSkillsController extends SkillsController {
  @override
  Future<SkillTree> build() async => SkillTree.demo();
}
