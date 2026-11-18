import 'package:flutter/material.dart';

import '../../app/theme/app_text_styles.dart';
import 'pixel_icon_button.dart';
import 'pixel_icons.dart';

/// Cabecera de pantallas de detalle: botón de volver (opcional), título y
/// acciones a la derecha.
class PixelHeader extends StatelessWidget {
  const PixelHeader({
    super.key,
    required this.title,
    this.onBack,
    this.actions = const [],
  });

  final String title;
  final VoidCallback? onBack;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onBack != null) ...[
          PixelIconButton(
            semanticLabel: 'Volver',
            onPressed: onBack,
            child: const PixelIcon(rows: PixelIcons.back),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        for (final action in actions) ...[
          const SizedBox(width: 12),
          action,
        ],
      ],
    );
  }
}
