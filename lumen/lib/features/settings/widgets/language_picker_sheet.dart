import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/pixel_panel.dart';

Future<String?> showLanguagePickerSheet(
  BuildContext context, {
  required String selectedCode,
}) =>
    showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.background,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('IDIOMA', style: AppTextStyles.title),
              const SizedBox(height: 16),
              for (final option in const [
                ('es', 'Español', 'Disponible'),
                ('en', 'English', 'Próximamente'),
              ]) ...[
                PixelPanel(
                  accent: option.$1 == selectedCode,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(option.$2, style: AppTextStyles.heading),
                    subtitle: Text(option.$3, style: AppTextStyles.caption),
                    trailing: option.$1 == selectedCode
                        ? const Icon(Icons.check, color: AppColors.primaryLight)
                        : null,
                    onTap: option.$1 == 'es'
                        ? () => Navigator.pop(context, option.$1)
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
