import 'package:flutter/widgets.dart';

/// Dibuja arte pixelado a partir de una matriz de caracteres.
/// Cada carácter se busca en [palette]; los que no estén quedan vacíos.
class PixelSprite extends StatelessWidget {
  const PixelSprite({
    super.key,
    required this.rows,
    required this.palette,
    this.pixel = 8,
  });

  final List<String> rows;
  final Map<String, Color> palette;
  final double pixel;

  @override
  Widget build(BuildContext context) {
    final columns = rows.fold<int>(0, (m, r) => r.length > m ? r.length : m);
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size(columns * pixel, rows.length * pixel),
        painter: _SpritePainter(rows, palette, pixel),
      ),
    );
  }
}

class _SpritePainter extends CustomPainter {
  const _SpritePainter(this.rows, this.palette, this.pixel);

  final List<String> rows;
  final Map<String, Color> palette;
  final double pixel;

  @override
  void paint(Canvas canvas, Size size) {
    for (var r = 0; r < rows.length; r++) {
      final row = rows[r];
      for (var c = 0; c < row.length; c++) {
        final color = palette[row[c]];
        if (color == null) continue;
        canvas.drawRect(
          Rect.fromLTWH(c * pixel, r * pixel, pixel, pixel),
          Paint()
            ..color = color
            ..isAntiAlias = false,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SpritePainter old) =>
      old.rows != rows || old.palette != palette || old.pixel != pixel;
}
