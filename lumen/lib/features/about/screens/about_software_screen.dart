import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config/app_config.dart';
import '../../../app/router/navigation.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/pixel_button.dart';
import '../../../core/widgets/pixel_dialog.dart';
import '../../../core/widgets/pixel_header.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/pixel_tile.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../data/about_content.dart';
import '../widgets/info_row.dart';

class AboutSoftwareScreen extends StatelessWidget {
  const AboutSoftwareScreen({super.key});

  static String _device(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final platform = switch (defaultTargetPlatform) {
      TargetPlatform.android => 'Android',
      TargetPlatform.iOS => 'iOS',
      TargetPlatform.windows => 'Windows',
      TargetPlatform.macOS => 'macOS',
      TargetPlatform.linux => 'Linux',
      TargetPlatform.fuchsia => 'Fuchsia',
    };
    return '$platform, ${size.width.round()} × ${size.height.round()} px';
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      centered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PixelHeader(
            title: 'Acerca del software',
            onBack: () => context.backOr(AppRoutes.settings),
          ),
          const SizedBox(height: 20),
          PixelPanel(
            title: 'Ficha técnica',
            accent: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoRow(
                  label: 'Versión de la app',
                  value: 'v${AppConfig.version}',
                  detail: '${AboutContent.appName}, compilación de desarrollo',
                ),
                const SizedBox(height: 14),
                const InfoRow(
                  label: 'Motor del juego',
                  value: AboutContent.gameEngine,
                ),
                const SizedBox(height: 14),
                const InfoRow(
                  label: 'Plataforma del juego',
                  value: AboutContent.gamePlatform,
                ),
                const SizedBox(height: 14),
                const InfoRow(
                  label: 'Esta app',
                  value: AboutContent.appFramework,
                ),
                const SizedBox(height: 14),
                InfoRow(label: 'Este dispositivo', value: _device(context)),
                const SizedBox(height: 14),
                const InfoRow(
                  label: 'Desarrollador principal',
                  value: AboutContent.leadDeveloper,
                  detail: AboutContent.leadDeveloperRole,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text('CARACTERÍSTICAS CLAVE', style: AppTextStyles.label),
          const SizedBox(height: 8),
          for (final feature in AboutContent.features) ...[
            PixelTile(
              title: feature.title,
              onTap: () => showPixelDialog(
                context: context,
                title: feature.title,
                message: feature.detail,
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 14),
          PixelButton(
            label: 'Créditos del estudio',
            variant: PixelButtonVariant.secondary,
            onPressed: () => context.push(AppRoutes.aboutTeam),
          ),
          const SizedBox(height: 8),
          PixelButton(
            label: 'Volver al menú principal',
            onPressed: () => context.go(AppRoutes.home),
          ),
        ],
      ),
    );
  }
}
