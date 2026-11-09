import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

/// Logotipo tipográfico provisional. Se sustituye por el logo real cuando
/// exista como asset.
class LumenLogo extends StatelessWidget {
  const LumenLogo({super.key, this.fontSize = 56});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final base = AppTextStyles.display.copyWith(fontSize: fontSize);
    return Semantics(
      label: 'Lumen',
      child: ExcludeSemantics(
        child: Stack(
          children: [
            Transform.translate(
              offset: const Offset(4, 4),
              child: Text('LUMEN', style: base.copyWith(color: AppColors.primaryDark)),
            ),
            Text('LUMEN', style: base),
          ],
        ),
      ),
    );
  }
}
