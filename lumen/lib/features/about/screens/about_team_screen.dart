import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/navigation.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/pixel_button.dart';
import '../../../core/widgets/pixel_header.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../data/about_content.dart';

class AboutTeamScreen extends StatelessWidget {
  const AboutTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final secondary = AppTextStyles.body.copyWith(
      color: AppColors.textSecondary,
    );
    return ScreenScaffold(
      centered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PixelHeader(
            title: 'Acerca del equipo',
            onBack: () => context.backOr(AppRoutes.settings),
          ),
          const SizedBox(height: 20),
          PixelPanel(
            title: 'Equipo de desarrollo: ${AboutContent.studioName}',
            accent: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (index, member) in AboutContent.team.indexed) ...[
                  if (index > 0) const SizedBox(height: 14),
                  Text(member.name, style: AppTextStyles.heading),
                  Text(member.role, style: AppTextStyles.body),
                  Text(
                    'github.com/${member.github}',
                    style: AppTextStyles.caption,
                  ),
                ],
                const SizedBox(height: 14),
                Text(
                  'Equipo central: ${AboutContent.team.length} personas',
                  style: secondary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PixelPanel(
            title: 'Proyecto',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  AboutContent.projectName,
                  style: AppTextStyles.heading,
                ),
                const SizedBox(height: 6),
                Text(
                  'Videojuego 3D para Windows y su app complementaria '
                  '${AboutContent.appName}.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 6),
                const Text(
                  AboutContent.repository,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const PixelPanel(
            title: 'Misión',
            child: Text(AboutContent.mission, style: AppTextStyles.body),
          ),
          const SizedBox(height: 16),
          PixelPanel(
            title: 'Herramientas',
            child: Text(
              AboutContent.tools.join(', '),
              style: AppTextStyles.body,
            ),
          ),
          const SizedBox(height: 24),
          PixelButton(
            label: 'Información del software',
            variant: PixelButtonVariant.secondary,
            onPressed: () => context.push(AppRoutes.aboutSoftware),
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
