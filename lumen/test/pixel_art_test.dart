import 'package:flutter_test/flutter_test.dart';

// Imports relativos a propósito: funcionan sin conocer el nombre del paquete.
// ignore_for_file: avoid_relative_lib_imports
import '../lib/core/widgets/pixel_icons.dart';
import '../lib/features/player/widgets/robot_avatar.dart';

void expectRectangular(String name, List<String> rows, String allowed) {
  expect(rows, isNotEmpty, reason: name);
  final width = rows.first.length;
  for (final row in rows) {
    expect(row.length, width, reason: '$name: fila "$row" de ancho distinto');
    expect(RegExp('^[$allowed]+\$').hasMatch(row), isTrue,
        reason: '$name: carácter no permitido en "$row"');
  }
}

void main() {
  test('los iconos son matrices 8x8 válidas', () {
    for (final entry in {
      'home': PixelIcons.home,
      'quests': PixelIcons.quests,
      'inventory': PixelIcons.inventory,
      'codex': PixelIcons.codex,
      'leaderboard': PixelIcons.leaderboard,
      'gear': PixelIcons.gear,
      'back': PixelIcons.back,
    }.entries) {
      expectRectangular(entry.key, entry.value, r'#.');
      expect(entry.value.length, 8, reason: entry.key);
      expect(entry.value.first.length, 8, reason: entry.key);
    }
  });

  test('los avatares son matrices 12x12 válidas y con id único', () {
    final ids = <String>{};
    for (final avatar in RobotAvatars.all) {
      expectRectangular(avatar.id, avatar.rows, r'#.e');
      expect(avatar.rows.length, 12, reason: avatar.id);
      expect(avatar.rows.first.length, 12, reason: avatar.id);
      expect(ids.add(avatar.id), isTrue, reason: 'id repetido ${avatar.id}');
    }
    expect(RobotAvatars.byId('no-existe').id, RobotAvatars.defaultId);
  });
}
