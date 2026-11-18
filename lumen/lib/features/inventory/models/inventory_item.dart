enum ItemType {
  weapon('Arma'),
  consumable('Consumible'),
  armor('Blindaje'),
  blueprint('Plano'),
  tool('Herramienta'),
  component('Componente'),
  currency('Moneda');

  const ItemType(this.label);

  final String label;
}

class ItemStat {
  const ItemStat(this.label, this.value);

  final String label;
  final String value;
}

class InventoryItem {
  const InventoryItem({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.quantity,
    this.capacity,
    this.stats = const [],
  });

  final String id;
  final String name;
  final ItemType type;
  final String description;
  final int quantity;
  final int? capacity;
  final List<ItemStat> stats;

  double? get fill {
    final max = capacity;
    if (max == null || max <= 0) return null;
    return (quantity / max).clamp(0.0, 1.0).toDouble();
  }

  String get summary {
    final parts = <String>[
      if (capacity != null) 'Cant. $quantity de $capacity',
      for (final stat in stats) '${stat.label} ${stat.value}',
    ];
    return parts.join('   ');
  }
}
