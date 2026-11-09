import 'package:flutter/widgets.dart';

import '../../app/theme/app_colors.dart';

/// Escena facetada y retícula en perspectiva inspiradas en juegos 3D clásicos.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF292A26),
              AppColors.surface,
              AppColors.background,
            ],
            stops: [0, 0.48, 1],
          ),
        ),
        child: CustomPaint(painter: const _ScenePainter(), child: child),
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  const _ScenePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final horizon = size.height * 0.54;
    final width = size.width;

    _drawPolygon(canvas, size, const [
      Offset(0, 0.54),
      Offset(0.13, 0.46),
      Offset(0.25, 0.52),
      Offset(0.40, 0.39),
      Offset(0.55, 0.51),
      Offset(0.70, 0.43),
      Offset(0.84, 0.51),
      Offset(1, 0.45),
      Offset(1, 0.62),
      Offset(0, 0.62),
    ], const Color(0xFF171B1B));
    _drawPolygon(canvas, size, const [
      Offset(0, 0.57),
      Offset(0.25, 0.52),
      Offset(0.40, 0.39),
      Offset(0.34, 0.59),
      Offset(0.17, 0.62),
    ], const Color(0xFF20221F));
    _drawPolygon(canvas, size, const [
      Offset(0.55, 0.51),
      Offset(0.70, 0.43),
      Offset(0.84, 0.51),
      Offset(0.73, 0.60),
    ], const Color(0xFF20221F));

    final horizonPaint = Paint()
      ..color = const Color(0x557A7770)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, horizon), Offset(width, horizon), horizonPaint);

    final gridPaint = Paint()
      ..color = AppColors.gridLine
      ..strokeWidth = 1;
    for (var index = 0; index <= 16; index++) {
      final bottomX = width * index / 16;
      canvas.drawLine(Offset(width / 2, horizon), Offset(bottomX, size.height), gridPaint);
    }
    for (var index = 1; index <= 9; index++) {
      final depth = index / 9;
      final y = horizon + (size.height - horizon) * depth * depth;
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }
  }

  void _drawPolygon(Canvas canvas, Size size, List<Offset> points, Color color) {
    final path = Path()
      ..moveTo(points.first.dx * size.width, points.first.dy * size.height);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx * size.width, point.dy * size.height);
    }
    canvas.drawPath(path..close(), Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _ScenePainter oldDelegate) => false;
}
