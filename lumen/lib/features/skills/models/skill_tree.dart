import '../../../core/errors/app_failure.dart';

enum SkillBranch { combat, exploration, support }

class SkillDefinition {
  const SkillDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.branch,
    required this.baseCost,
    this.maxLevel = 1,
    this.prerequisites = const [],
  });

  final String id;
  final String name;
  final String description;
  final SkillBranch branch;
  final int baseCost;
  final int maxLevel;
  final List<String> prerequisites;

  int costAt(int level) => baseCost + level;
}

class SkillTree {
  const SkillTree({
    required this.points,
    required this.skills,
    required this.levels,
  });

  static const List<SkillDefinition> definitions = [
    SkillDefinition(
      id: 'impact',
      name: 'Impacto preciso',
      description: 'Aumenta el daño del primer ataque.',
      branch: SkillBranch.combat,
      baseCost: 1,
      maxLevel: 3,
    ),
    SkillDefinition(
      id: 'overload',
      name: 'Sobrecarga',
      description: 'Mejora el daño de los ataques cargados.',
      branch: SkillBranch.combat,
      baseCost: 2,
      prerequisites: ['impact'],
    ),
    SkillDefinition(
      id: 'scanner',
      name: 'Escáner de rastros',
      description: 'Revela coleccionables cercanos.',
      branch: SkillBranch.exploration,
      baseCost: 1,
      maxLevel: 3,
    ),
    SkillDefinition(
      id: 'salvage',
      name: 'Recuperación eficiente',
      description: 'Aumenta los materiales obtenidos.',
      branch: SkillBranch.exploration,
      baseCost: 2,
      prerequisites: ['scanner'],
    ),
    SkillDefinition(
      id: 'repair',
      name: 'Reparación rápida',
      description: 'Recupera más integridad al usar kits.',
      branch: SkillBranch.support,
      baseCost: 1,
      maxLevel: 3,
    ),
    SkillDefinition(
      id: 'shield',
      name: 'Blindaje adaptativo',
      description: 'Reduce el daño recibido tras esquivar.',
      branch: SkillBranch.support,
      baseCost: 2,
      prerequisites: ['repair'],
    ),
  ];

  factory SkillTree.demo() => SkillTree(
        points: 6,
        skills: definitions,
        levels: const {},
      );

  final int points;
  final List<SkillDefinition> skills;
  final Map<String, int> levels;

  int levelOf(String id) => levels[id] ?? 0;

  int get pointsSpent => levels.entries.fold<int>(0, (total, entry) {
        final skill = _definition(entry.key);
        if (skill == null) return total;
        return total +
            List<int>.generate(
              entry.value,
              (index) => skill.costAt(index),
            ).fold<int>(0, (sum, cost) => sum + cost);
      });

  int get totalPoints => points + pointsSpent;

  int nextCost(String id) {
    final skill = _definition(id);
    if (skill == null) throw const RuleFailure('Habilidad desconocida.');
    return skill.costAt(levelOf(id));
  }

  bool isAvailable(SkillDefinition skill) =>
      skill.prerequisites.every((id) => levelOf(id) > 0);

  SkillTree upgrade(String id) {
    final skill = _definition(id);
    if (skill == null) throw const RuleFailure('Habilidad desconocida.');
    final level = levelOf(id);
    if (!isAvailable(skill)) {
      throw const RuleFailure('Desbloquea primero las habilidades anteriores.');
    }
    if (level >= skill.maxLevel) {
      throw const RuleFailure('Esta habilidad ya alcanzó su nivel máximo.');
    }
    final cost = skill.costAt(level);
    if (points < cost) {
      throw const RuleFailure('No tienes suficientes puntos de habilidad.');
    }

    return SkillTree(
      points: points - cost,
      skills: skills,
      levels: {...levels, id: level + 1},
    );
  }

  SkillTree respec() {
    return SkillTree(
      points: totalPoints,
      skills: skills,
      levels: const {},
    );
  }

  SkillDefinition? _definition(String id) {
    for (final skill in skills) {
      if (skill.id == id) return skill;
    }
    return null;
  }
}
