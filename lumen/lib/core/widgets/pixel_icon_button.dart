import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Botón cuadrado para iconos (volver, ajustes...). Requiere una etiqueta
/// de accesibilidad porque no tiene texto.
class PixelIconButton extends StatefulWidget {
  const PixelIconButton({
    super.key,
    required this.child,
    required this.semanticLabel,
    required this.onPressed,
    this.size = 44,
  });

  final Widget child;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final double size;

  @override
  State<PixelIconButton> createState() => _PixelIconButtonState();
}

class _PixelIconButtonState extends State<PixelIconButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      onTap: widget.onPressed,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _enabled ? (_) => _setPressed(true) : null,
        onTapUp: _enabled ? (_) => _setPressed(false) : null,
        onTapCancel: _enabled ? () => _setPressed(false) : null,
        onTap: widget.onPressed,
        child: Container(
          width: widget.size,
          height: widget.size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _pressed ? AppColors.primaryLight : AppColors.surfaceRaised,
            border: Border.all(
              color: _pressed ? AppColors.primaryDark : AppColors.metal,
              width: 3,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
