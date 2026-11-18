import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

/// Tarjeta tocable con título, resumen de una línea y flecha. Se hunde al
/// presionarla, igual que los botones.
class PixelNavCard extends StatefulWidget {
  const PixelNavCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<PixelNavCard> createState() => _PixelNavCardState();
}

class _PixelNavCardState extends State<PixelNavCard> {
  static const double _depth = 4;

  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final offset = _pressed ? _depth : 0.0;
    return Semantics(
      button: true,
      label: '${widget.title}. ${widget.subtitle}',
      onTap: widget.onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.only(right: _depth, bottom: _depth),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 70),
            padding: const EdgeInsets.all(16),
            transform: Matrix4.translationValues(offset, offset, 0),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(
                color: _pressed ? AppColors.primaryLight : AppColors.metal,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.detail,
                  offset: Offset(_depth - offset, _depth - offset),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title, style: AppTextStyles.heading),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '>',
                  style: AppTextStyles.title.copyWith(color: AppColors.primaryLight),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
