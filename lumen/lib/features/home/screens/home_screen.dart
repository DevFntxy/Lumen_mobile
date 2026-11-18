import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/pixel_icon_button.dart';
import '../../../core/widgets/pixel_icons.dart';
import '../../../core/widgets/pixel_nav_card.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/state_views.dart';
import '../../auth/providers/auth_providers.dart';
import '../../player/models/player_progress.dart';
import '../../player/providers/player_providers.dart';
import '../../player/widgets/robot_avatar.dart';
import '../widgets/act_summary_panel.dart';

/// SCR-05. Avatar y usuario (abre el perfil), resumen del acto y accesos a
/// progreso, códex y logros. Los demás módulos están en la barra inferior.
///
/// Salidas: Perfil (SCR-06), Ajustes (SCR-13), Progreso (SCR-07),
/// Códex (SCR-08) y Logros (SCR-10).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(
      authControllerProvider.select((s) => s.user?.displayName),
    );
    final avatarId = ref.watch(playerProfileProvider).value?.avatarId ??
        RobotAvatars.defaultId;
    final progress = ref.watch(playerProgressProvider);

    return ScreenScaffold(
      centered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HomeHeader(username: username ?? 'Operador', avatarId: avatarId),
          const SizedBox(height: 24),
          AsyncValueView<PlayerProgress?>(
            value: progress,
            loadingMessage: 'Cargando datos de M-4...',
            onRetry: () => ref.invalidate(playerProgressProvider),
            data: (data) => data == null
                ? const EmptyState(
                    title: 'Aún no hay partida',
                    message: 'Cuando juegues LUMEN en tu PC y sincronices tu '
                        'cuenta, tu progreso aparecerá aquí.',
                  )
                : _ProgressContent(progress: data),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.username, required this.avatarId});

  final String username;
  final String avatarId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: PixelIconButton(
            semanticLabel: 'Ajustes',
            onPressed: () => context.push(AppRoutes.settings),
            child: const PixelIcon(rows: PixelIcons.gear),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                button: true,
                label: 'Ver perfil de $username',
                excludeSemantics: true,
                onTap: () => context.push(AppRoutes.profile),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.push(AppRoutes.profile),
                  child: Container(
                    width: 88,
                    height: 88,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceRaised,
                      border: Border.all(color: AppColors.primaryLight, width: 3),
                      boxShadow: const [
                        BoxShadow(color: AppColors.detail, offset: Offset(4, 4)),
                      ],
                    ),
                    child: RobotAvatar(avatarId: avatarId, pixel: 5),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(username, style: AppTextStyles.title),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressContent extends StatelessWidget {
  const _ProgressContent({required this.progress});

  final PlayerProgress progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ActSummaryPanel(progress: progress),
        const SizedBox(height: 20),
        PixelNavCard(
          title: 'Resumen de progreso',
          subtitle: '${progress.zonesUnlocked} de ${progress.zonesTotal} '
              'zonas desbloqueadas',
          onTap: () => context.push(AppRoutes.progress),
        ),
        const SizedBox(height: 12),
        PixelNavCard(
          title: 'Índice del códex',
          subtitle: '${progress.codexUnlocked} de ${progress.codexTotal} '
              'fichas desbloqueadas',
          onTap: () => context.go(AppRoutes.codex),
        ),
        const SizedBox(height: 12),
        PixelNavCard(
          title: 'Registro de logros',
          subtitle: '${progress.achievementsUnlocked} de '
              '${progress.achievementsTotal} logros obtenidos',
          onTap: () => context.push(AppRoutes.achievements),
        ),
      ],
    );
  }
}
