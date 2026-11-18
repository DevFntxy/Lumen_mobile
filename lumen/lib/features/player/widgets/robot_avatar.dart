import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/pixel_sprite.dart';

class RobotAvatarData {
  const RobotAvatarData({
    required this.id,
    required this.name,
    required this.rows,
  });

  final String id;
  final String name;
  final List<String> rows;
}

/// Avatares disponibles. `#` es el chasis y `e` los ojos.
abstract final class RobotAvatars {
  static const String defaultId = 'm4';

  static const List<RobotAvatarData> all = [
    RobotAvatarData(
      id: 'm4',
      name: 'M-4',
      rows: [
        '.....##.....',
        '.....##.....',
        '.##########.',
        '#..........#',
        '#.ee....ee.#',
        '#.ee....ee.#',
        '#..........#',
        '#..######..#',
        '#..........#',
        '.##########.',
        '...######...',
        '..########..',
      ],
    ),
    RobotAvatarData(
      id: 'sentinel',
      name: 'Centinela',
      rows: [
        '.....##.....',
        '.....##.....',
        '.##########.',
        '#..........#',
        '#.eeeeeeee.#',
        '#.eeeeeeee.#',
        '#..........#',
        '#..#.##.#..#',
        '#..........#',
        '.##########.',
        '...######...',
        '..########..',
      ],
    ),
    RobotAvatarData(
      id: 'a7',
      name: 'A-7',
      rows: [
        '..#......#..',
        '..#......#..',
        '.##########.',
        '#..........#',
        '#..ee..ee..#',
        '#..ee..ee..#',
        '#..........#',
        '#...####...#',
        '#..........#',
        '.##########.',
        '...######...',
        '..########..',
      ],
    ),
    RobotAvatarData(
      id: 'scavenger',
      name: 'Carroñero',
      rows: [
        '.....##.....',
        '..#..##..#..',
        '.##########.',
        '#..........#',
        '#.ee....e..#',
        '#.ee...ee..#',
        '#..........#',
        '#.########.#',
        '#..........#',
        '.##########.',
        '...######...',
        '..########..',
      ],
    ),
  ];

  static RobotAvatarData byId(String id) =>
      all.firstWhere((a) => a.id == id, orElse: () => all.first);
}

/// Dibuja el avatar con el identificador dado.
class RobotAvatar extends StatelessWidget {
  const RobotAvatar({super.key, required this.avatarId, this.pixel = 6});

  final String avatarId;
  final double pixel;

  static const Map<String, Color> _palette = {
    '#': AppColors.textPrimary,
    'e': AppColors.primaryLight,
  };

  @override
  Widget build(BuildContext context) {
    final data = RobotAvatars.byId(avatarId);
    return Semantics(
      label: 'Avatar ${data.name}',
      child: PixelSprite(rows: data.rows, palette: _palette, pixel: pixel),
    );
  }
}
