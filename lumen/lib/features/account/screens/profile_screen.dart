import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/navigation.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/async_form_mixin.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/pixel_button.dart';
import '../../../core/widgets/pixel_dialog.dart';
import '../../../core/widgets/pixel_header.dart';
import '../../../core/widgets/pixel_icon_button.dart';
import '../../../core/widgets/pixel_icons.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/status_console.dart';
import '../../auth/models/auth_user.dart';
import '../../auth/providers/auth_providers.dart';
import '../../player/models/player_profile.dart';
import '../../player/providers/player_providers.dart';
import '../../player/widgets/robot_avatar.dart';
import '../widgets/avatar_picker_sheet.dart';
import '../widgets/linked_providers_panel.dart';
import '../widgets/profile_field.dart';

/// SCR-06. Avatar seleccionable, datos de la cuenta, cuentas vinculadas,
/// cerrar sesión y eliminar cuenta.
///
/// Salidas: Inicio (SCR-05) con el botón de volver y Ajustes (SCR-13).
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with AsyncFormMixin<ProfileScreen> {
  Future<void> _pickAvatar(String current) async {
    final picked = await showAvatarPicker(context, current: current);
    if (picked == null || picked == current || !mounted) return;
    final ok = await runGuarded(
      () => ref.read(playerProfileProvider.notifier).selectAvatar(picked),
      progress: 'Guardando avatar...',
    );
    if (ok) setStatus('Avatar actualizado.');
  }

  Future<void> _logout() async {
    await runGuarded(
      () => ref.read(authControllerProvider.notifier).logout(),
      progress: 'Cerrando sesión...',
    );
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showPixelConfirmDialog(
      context: context,
      title: 'Eliminar cuenta',
      message: 'Se borrarán tu cuenta y tu progreso sincronizado. '
          'Esta acción no se puede deshacer.',
      confirmLabel: 'Eliminar cuenta',
    );
    if (!confirmed || !mounted) return;
    await runGuarded(
      () => ref.read(authControllerProvider.notifier).deleteAccount(),
      progress: 'Eliminando cuenta...',
    );
  }

  Widget _body(PlayerProfile profile, AuthUser? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          label: 'Cambiar avatar',
          excludeSemantics: true,
          onTap: busy ? null : () => _pickAvatar(profile.avatarId),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: busy ? null : () => _pickAvatar(profile.avatarId),
            child: PixelPanel(
              title: 'Avatar',
              accent: true,
              child: Column(
                children: [
                  RobotAvatar(avatarId: profile.avatarId, pixel: 12),
                  const SizedBox(height: 12),
                  const Text('Toca para cambiar de avatar', style: AppTextStyles.caption),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ProfileField(label: 'Usuario', value: user?.displayName ?? '-'),
        const SizedBox(height: 14),
        ProfileField(label: 'Correo', value: user?.email ?? '-'),
        const SizedBox(height: 14),
        ProfileField(
          label: 'Cuenta creada',
          value: formatDate(profile.accountCreated),
        ),
        const SizedBox(height: 20),
        LinkedProvidersPanel(providers: profile.linkedProviders),
        const SizedBox(height: 24),
        PixelButton(
          label: 'Cerrar sesión',
          variant: PixelButtonVariant.secondary,
          onPressed: busy ? null : _logout,
        ),
        const SizedBox(height: 8),
        PixelButton(
          label: 'Eliminar cuenta',
          onPressed: busy ? null : _deleteAccount,
        ),
        if (status.isNotEmpty) ...[
          const SizedBox(height: 20),
          StatusConsole(message: status, isError: statusIsError),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider.select((s) => s.user));
    final profile = ref.watch(playerProfileProvider);

    return ScreenScaffold(
      centered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PixelHeader(
            title: 'Perfil',
            onBack: () => context.backOr(AppRoutes.home),
            actions: [
              PixelIconButton(
                semanticLabel: 'Ajustes',
                onPressed: () => context.push(AppRoutes.settings),
                child: const PixelIcon(rows: PixelIcons.gear),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AsyncValueView<PlayerProfile>(
            value: profile,
            loadingMessage: 'Cargando perfil...',
            onRetry: () => ref.invalidate(playerProfileProvider),
            data: (data) => _body(data, user),
          ),
        ],
      ),
    );
  }
}
