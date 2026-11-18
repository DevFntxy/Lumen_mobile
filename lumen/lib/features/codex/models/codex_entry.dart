class CodexEntry {
  const CodexEntry({
    required this.id,
    required this.name,
    required this.description,
    required this.isUnlocked,
    this.avatarId,
  });

  final String id;
  final String name;
  final String description;
  final bool isUnlocked;
  final String? avatarId;
}
