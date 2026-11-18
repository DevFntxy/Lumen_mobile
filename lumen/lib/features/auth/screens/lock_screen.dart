import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config/app_config.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/async_form_mixin.dart';
import '../../../core/widgets/pixel_button.dart';
import '../../../core/widgets/pixel_dialog.dart';
import '../../../core/widgets/pixel_link.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/status_console.dart';
import '../providers/auth_providers.dart';
import '../widgets/lock_shield.dart';

/// SCR-19. Se muestra al agotar los intentos de login.
///
/// Flujos de salida:
/// - "Desbloquear cuenta": solicita un código y abre Desbloqueo (SCR-20).
/// - "Volver al inicio de sesión": Login (SCR-02).
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen>
    with AsyncFormMixin<LockScreen> {
  @override
  void initState() {
    super.initState();
    status = 'Para volver a entrar, desbloquea tu cuenta con un código '
        'que enviaremos a tu correo.';
  }

  Future<void> _requestUnlock() async {
    final ok = await runGuarded(
      () => ref.read(authRepositoryProvider).requestUnlockCode(),
      progress: 'Enviando código de seguridad...',
    );
    if (ok && mounted) {
      context.go(
        AppRoutes.unlock,
        extra: 'Código enviado. Revisa tu correo e ingresa los 6 dígitos.',
      );
    }
  }

  void _contactSupport() {
    showPixelDialog(
      context: context,
      title: 'Soporte técnico',
      message: 'Escríbenos a ${AppConfig.supportEmail} indicando el correo '
          'de tu cuenta y te ayudaremos a recuperar el acceso.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: LockShield()),
          const SizedBox(height: 24),
          const Text(
            'Cuenta bloqueada',
            textAlign: TextAlign.center,
            style: AppTextStyles.title,
          ),
          const SizedBox(height: 8),
          Text(
            'Motivo: intentos fallidos de inicio de sesión.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 28),
          PixelButton(
            label: 'Desbloquear cuenta',
            isLoading: busy,
            onPressed: busy ? null : _requestUnlock,
          ),
          const SizedBox(height: 8),
          PixelButton(
            label: 'Contactar soporte',
            variant: PixelButtonVariant.secondary,
            compact: true,
            onPressed: busy ? null : _contactSupport,
          ),
          const SizedBox(height: 20),
          StatusConsole(message: status, isError: statusIsError),
          const SizedBox(height: 8),
          Center(
            child: PixelLink(
              label: 'Volver al inicio de sesión',
              onPressed: busy ? null : () => context.go(AppRoutes.login),
            ),
          ),
        ],
      ),
    );
  }
}
