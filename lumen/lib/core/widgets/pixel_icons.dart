import 'package:flutter/widgets.dart';

import '../../app/theme/app_colors.dart';
import 'pixel_sprite.dart';

/// Iconos de 8×8 píxeles. `#` es el trazo.
abstract final class PixelIcons {
  static const List<String> home = [
    '...##...',
    '..####..',
    '.######.',
    '########',
    '.##..##.',
    '.##..##.',
    '.##..##.',
    '.######.',
  ];

  static const List<String> quests = [
    '.######.',
    '.#....#.',
    '.#.##.#.',
    '.#....#.',
    '.#.##.#.',
    '.#....#.',
    '.#.##.#.',
    '.######.',
  ];

  static const List<String> inventory = [
    '..####..',
    '.#....#.',
    '.######.',
    '########',
    '#......#',
    '#..##..#',
    '#......#',
    '########',
  ];

  static const List<String> codex = [
    '.#######',
    '##.....#',
    '##.###.#',
    '##.....#',
    '##.###.#',
    '##.....#',
    '##.....#',
    '.#######',
  ];

  static const List<String> leaderboard = [
    '########',
    '#.####.#',
    '#.####.#',
    '.######.',
    '..####..',
    '...##...',
    '...##...',
    '..####..',
  ];

  static const List<String> gear = [
    '...##...',
    '.#.##.#.',
    '..####..',
    '##....##',
    '##....##',
    '..####..',
    '.#.##.#.',
    '...##...',
  ];

  static const List<String> back = [
    '....#...',
    '...##...',
    '..###...',
    '.#######',
    '.#######',
    '..###...',
    '...##...',
    '....#...',
  ];
}

/// Dibuja uno de los [PixelIcons] en un solo color.
class PixelIcon extends StatelessWidget {
  const PixelIcon({
    super.key,
    required this.rows,
    this.color = AppColors.unselected,
    this.pixel = 3,
  });

  final List<String> rows;
  final Color color;
  final double pixel;

  @override
  Widget build(BuildContext context) {
    return PixelSprite(rows: rows, palette: {'#': color}, pixel: pixel);
  }
}
