import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Indicador de carga de cuatro bloques que se encienden en secuencia.
class PixelLoadingDots extends StatefulWidget {
  const PixelLoadingDots({
    super.key,
    this.color = AppColors.unselected,
    this.size = 10,
  });

  final Color color;
  final double size;

  @override
  State<PixelLoadingDots> createState() => _PixelLoadingDotsState();
}

class _PixelLoadingDotsState extends State<PixelLoadingDots>
    with SingleTickerProviderStateMixin {
  static const int _count = 4;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Cargando',
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final active = (_controller.value * _count).floor() % _count;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < _count; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      color: i == active
                          ? widget.color
                          : widget.color.withAlpha(60),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
