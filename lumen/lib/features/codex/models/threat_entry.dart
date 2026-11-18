enum ThreatKind { enemy, boss }

class ThreatEntry {
  const ThreatEntry({
    required this.id,
    required this.name,
    required this.description,
    required this.kind,
    required this.avatarId,
    required this.isIdentified,
    this.weakness,
  });

  final String id;
  final String name;
  final String description;
  final ThreatKind kind;
  final String avatarId;
  final bool isIdentified;
  final String? weakness;
}
