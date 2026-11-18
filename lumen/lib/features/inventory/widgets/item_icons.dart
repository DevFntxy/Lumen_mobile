import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/pixel_icons.dart';
import '../models/inventory_item.dart';

abstract final class ItemIcons {
  static const List<String> weapon = [
    '.....##.',
    '....###.',
    '...###..',
    '..###...',
    '#.###...',
    '.###....',
    '.##.....',
    '#..#....',
  ];

  static const List<String> consumable = [
    '..####..',
    '.######.',
    '.#....#.',
    '.#.##.#.',
    '.#.##.#.',
    '.#....#.',
    '.######.',
    '..####..',
  ];

  static const List<String> armor = [
    '##.##.##',
    '########',
    '.######.',
    '.######.',
    '.######.',
    '.######.',
    '..####..',
    '...##...',
  ];

  static const List<String> blueprint = [
    '######..',
    '#....##.',
    '#.##.#.#',
    '#....###',
    '#.####.#',
    '#......#',
    '#.####.#',
    '########',
  ];

  static const List<String> tool = [
    '.#####..',
    '.#####..',
    '.#####..',
    '..###...',
    '..###...',
    '..###...',
    '..###...',
    '..###...',
  ];

  static const List<String> component = [
    '..####..',
    '.######.',
    '########',
    '#.####.#',
    '.#.##.#.',
    '..####..',
    '...##...',
    '....#...',
  ];

  static const List<String> currency = [
    '..####..',
    '.#....#.',
    '#..##..#',
    '#.####.#',
    '#.####.#',
    '#..##..#',
    '.#....#.',
    '..####..',
  ];

  static List<String> forType(ItemType type) => switch (type) {
    ItemType.weapon => weapon,
    ItemType.consumable => consumable,
    ItemType.armor => armor,
    ItemType.blueprint => blueprint,
    ItemType.tool => tool,
    ItemType.component => component,
    ItemType.currency => currency,
  };
}

class ItemIcon extends StatelessWidget {
  const ItemIcon({super.key, required this.type, this.pixel = 3});

  final ItemType type;
  final double pixel;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          border: Border.all(color: AppColors.metal, width: 3),
        ),
        child: PixelIcon(
          rows: ItemIcons.forType(type),
          color: AppColors.textPrimary,
          pixel: pixel,
        ),
      ),
    );
  }
}
