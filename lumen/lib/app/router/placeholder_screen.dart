import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/pixel_button.dart';
import '../../core/widgets/pixel_panel.dart';
import '../../core/widgets/screen_scaffold.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'screen_catalog.dart';

/// Pantalla provisional para las rutas aún no implementadas. Permite probar
/// el flujo de navegación completo. Se elimina cuando no queden pendientes.
class PlaceholderScreen extends ConsumerWidget {
  const PlaceholderScreen({super.key, required this.info});

  final ScreenInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PixelPanel(
            title: info.id,
            accent: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info.title, style: AppTextStyles.heading),
                const SizedBox(height: 8),
                Text(
                  'Pantalla pendiente de implementar.',
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Ir a:', style: AppTextStyles.label),
          const SizedBox(height: 8),
          for (final id in info.next)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: PixelButton(
                label: ScreenCatalog.byId(id).title,
                variant: PixelButtonVariant.secondary,
                onPressed: () => context.go(ScreenCatalog.byId(id).path),
              ),
            ),
          if (info.id == 'SCR-05') ...[
            const SizedBox(height: 12),
            PixelButton(
              label: 'Cerrar sesión',
              onPressed: () => ref.read(authControllerProvider.notifier).logout(),
            ),
          ],
        ],
      ),
    );
  }
}
