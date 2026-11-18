enum MemorySector { foundry, flooded, core }

class MemoryFragment {
  const MemoryFragment({
    required this.id,
    required this.title,
    required this.sector,
    required this.summary,
    required this.transcript,
    required this.isUnlocked,
  });

  final String id;
  final String title;
  final MemorySector sector;
  final String summary;
  final String transcript;
  final bool isUnlocked;
}
