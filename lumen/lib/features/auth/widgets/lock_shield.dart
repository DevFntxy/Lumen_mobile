import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/pixel_sprite.dart';

/// Escudo con candado en pixel art para la pantalla de cuenta bloqueada.
class LockShield extends StatelessWidget {
  const LockShield({super.key, this.pixel = 9});

  final double pixel;

  // # contorno · r relleno · w candado · k ojo de la cerradura
  static const List<String> _rows = [
    '.##############.',
    '#rrrrrrrrrrrrrr#',
    '#rrrrrrrrrrrrrr#',
    '#rrrrrwwwwrrrrr#',
    '#rrrrwrrrrwrrrr#',
    '#rrrrwrrrrwrrrr#',
    '#rrrwwwwwwwwrrr#',
    '#rrrwwwwwwwwrrr#',
    '#rrrwwwkkwwwrrr#',
    '#rrrwwwkkwwwrrr#',
    '#rrrwwwwwwwwrrr#',
    '#rrrwwwwwwwwrrr#',
    '.#rrrrrrrrrrrr#.',
    '.#rrrrrrrrrrrr#.',
    '..#rrrrrrrrrr#..',
    '...#rrrrrrrr#...',
    '....#rrrrrr#....',
    '.....#rrrr#.....',
    '......####......',
  ];

  static const Map<String, Color> _palette = {
    '#': AppColors.textPrimary,
    'r': AppColors.primaryDark,
    'w': AppColors.unselected,
    'k': AppColors.detail,
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Candado: cuenta bloqueada',
      child: PixelSprite(rows: _rows, palette: _palette, pixel: pixel),
    );
  }
}
