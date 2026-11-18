import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config/app_config.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/utils/async_form_mixin.dart';
import '../../../core/widgets/pixel_button.dart';
import '../../../core/widgets/pixel_dialog.dart';
import '../../../core/widgets/pixel_link.dart';
import '../../../core/widgets/pixel_otp_field.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/status_console.dart';
import '../providers/auth_providers.dart';

/// SCR-20. Verificación con código de 6 dígitos enviado por correo.
///
/// Flujos de salida:
/// - "Confirmar" con código válido: Login (SCR-02) con mensaje de éxito
///   (el desbloqueo no inicia sesión por sí solo: falta la contraseña).
/// - "Volver al inicio de sesión": Login (SCR-02).
class UnlockScreen extends ConsumerStatefulWidget {
  const UnlockScreen({super.key, this.initialMessage});

  final String? initialMessage;

  @override
  ConsumerState<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends ConsumerState<UnlockScreen>
    with AsyncFormMixin<UnlockScreen> {
  static const int _codeLength = 6;

  final _codeController = TextEditingController();
  bool _codeError = false;

  @override
  void initState() {
    super.initState();
    status = widget.initialMessage ??
        'Ingresa el código de 6 dígitos que enviamos a tu correo.';
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    FocusScope.of(context).unfocus();
    final code = _codeController.text;
    if (code.length < _codeLength) {
      setState(() => _codeError = true);
      setStatus('Escribe los $_codeLength dígitos del código.', error: true);
      return;
    }
    final ok = await runGuarded(
      () => ref.read(authRepositoryProvider).unlockAccount(code),
      progress: 'Verificando código...',
      onFailure: (failure) {
        if (failure is! InvalidCodeFailure) return false;
        _codeController.clear();
        setState(() => _codeError = true);
        setStatus(failure.message, error: true);
        return true;
      },
    );
    if (ok && mounted) {
      context.go(
        AppRoutes.login,
        extra: 'Cuenta desbloqueada. Inicia sesión para continuar.',
      );
    }
  }

  Future<void> _requestNewCode() async {
    final ok = await runGuarded(
      () => ref.read(authRepositoryProvider).requestUnlockCode(),
      progress: 'Enviando un nuevo código...',
    );
    if (!ok || !mounted) return;
    _codeController.clear();
    setState(() => _codeError = false);
    setStatus('Enviamos un nuevo código. El anterior ya no es válido.');
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
          const Text(
            'Desbloqueo de cuenta',
            textAlign: TextAlign.center,
            style: AppTextStyles.title,
          ),
          const SizedBox(height: 24),
          PixelPanel(
            title: 'Instrucciones de seguridad',
            child: Text(
              'Introduce el código de 6 dígitos enviado por correo.',
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 16),
          PixelPanel(
            title: 'Código de acceso (6 dígitos)',
            accent: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PixelOtpField(
                  controller: _codeController,
                  length: _codeLength,
                  enabled: !busy,
                  hasError: _codeError,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Si no lo encuentras, revisa tu carpeta de spam.',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PixelPanel(
            title: 'Opciones alternativas',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PixelLink(
                  label: 'Solicitar nuevo código',
                  onPressed: busy ? null : _requestNewCode,
                ),
                PixelLink(
                  label: 'Contactar soporte técnico',
                  onPressed: busy ? null : _contactSupport,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PixelButton(
            label: 'Confirmar',
            isLoading: busy,
            onPressed: busy ? null : _confirm,
          ),
          const SizedBox(height: 20),
          StatusConsole(message: status, isError: statusIsError),
          if (kDebugMode) ...[
            const SizedBox(height: 10),
            Text(
              'Demo: el código válido es ${MockData.demoOtp}',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
          ],
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
