import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import 'pixel_loading_dots.dart';

enum PixelButtonVariant {
  /// Seleccionado / acción principal: rojo (claro de relleno, oscuro de borde).
  primary,

  /// No seleccionado / acción secundaria: blanco.
  secondary,
}

/// Botón con relieve de bloque que se "hunde" al presionarlo.
/// `onPressed: null` lo deshabilita; `isLoading` muestra el indicador de carga
/// y bloquea nuevos toques.
class PixelButton extends StatefulWidget {
  const PixelButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PixelButtonVariant.primary,
    this.isLoading = false,
    this.expanded = true,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final PixelButtonVariant variant;
  final bool isLoading;
  final bool expanded;
  final bool compact;

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  static const double _depth = 4;

  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final isPrimary = widget.variant == PixelButtonVariant.primary;
    final disabled = widget.onPressed == null && !widget.isLoading;

    final face = disabled
        ? AppColors.metal
        : (isPrimary ? AppColors.primaryLight : AppColors.unselected);
    final edge = disabled
        ? AppColors.detail
        : (isPrimary ? AppColors.primaryDark : AppColors.metal);
    final textColor = disabled
        ? AppColors.textSecondary
        : (isPrimary ? AppColors.unselected : AppColors.detail);

    final offset = _pressed && _enabled ? _depth : 0.0;

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      onTap: _enabled ? widget.onPressed : null,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _enabled ? (_) => _setPressed(true) : null,
        onTapUp: _enabled ? (_) => _setPressed(false) : null,
        onTapCancel: _enabled ? () => _setPressed(false) : null,
        onTap: _enabled ? widget.onPressed : null,
        child: Padding(
          // Reserva el espacio de la "profundidad" para que el tamaño no varíe.
          padding: const EdgeInsets.only(right: _depth, bottom: _depth),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 70),
            width: widget.expanded ? double.infinity : null,
            alignment: widget.expanded ? Alignment.center : null,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: widget.compact ? 10 : 14,
            ),
            transform: Matrix4.translationValues(offset, offset, 0),
            decoration: BoxDecoration(
              color: face,
              border: Border.all(color: AppColors.detail, width: 3),
              boxShadow: [
                BoxShadow(
                  color: edge,
                  offset: Offset(_depth - offset, _depth - offset),
                ),
              ],
            ),
            child: widget.isLoading
                ? PixelLoadingDots(color: textColor, size: 8)
                : Text(
                    widget.label.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.button.copyWith(
                      color: textColor,
                      fontSize: widget.compact ? 15 : 18,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
