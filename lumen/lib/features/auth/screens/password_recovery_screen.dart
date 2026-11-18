import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show AutofillHints;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/utils/async_form_mixin.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/pixel_button.dart';
import '../../../core/widgets/pixel_link.dart';
import '../../../core/widgets/pixel_otp_field.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/pixel_text_field.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/status_console.dart';
import '../providers/auth_providers.dart';

/// SCR-04. Tres pasos en una sola pantalla, como en el sketch:
/// 1) correo → enviar código, 2) código de 6 dígitos (se verifica al
/// completarlo), 3) nueva contraseña.
///
/// Flujo de salida: Login (SCR-02), con mensaje de confirmación al terminar.
class PasswordRecoveryScreen extends ConsumerStatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  ConsumerState<PasswordRecoveryScreen> createState() =>
      _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends ConsumerState<PasswordRecoveryScreen>
    with AsyncFormMixin<PasswordRecoveryScreen> {
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _confirmFocus = FocusNode();

  int _step = 1;
  bool _codeError = false;

  @override
  void initState() {
    super.initState();
    status = 'Sigue los tres pasos para recuperar tu acceso.';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  String get _email => _emailController.text.trim();

  Future<void> _sendCode() async {
    FocusScope.of(context).unfocus();
    if (!(_emailKey.currentState?.validate() ?? false)) return;
    final ok = await runGuarded(
      () => ref.read(authRepositoryProvider).requestPasswordReset(_email),
      progress: 'Enviando código...',
    );
    if (!ok || !mounted) return;
    _codeController.clear();
    setState(() {
      _step = 2;
      _codeError = false;
    });
    setStatus('Código enviado. Revisa tu correo y la carpeta de spam.');
  }

  Future<void> _verifyCode(String code) async {
    FocusScope.of(context).unfocus();
    final ok = await runGuarded(
      () => ref
          .read(authRepositoryProvider)
          .verifyResetCode(email: _email, code: code),
      progress: 'Verificando código...',
      onFailure: (failure) {
        if (failure is! InvalidCodeFailure) return false;
        _codeController.clear();
        setState(() => _codeError = true);
        setStatus(failure.message, error: true);
        return true;
      },
    );
    if (!ok || !mounted) return;
    setState(() {
      _step = 3;
      _codeError = false;
    });
    setStatus('Código verificado. Elige tu nueva contraseña.');
  }

  Future<void> _resetPassword() async {
    FocusScope.of(context).unfocus();
    if (!(_passwordKey.currentState?.validate() ?? false)) return;
    final ok = await runGuarded(
      () => ref.read(authRepositoryProvider).resetPassword(
            email: _email,
            code: _codeController.text,
            newPassword: _passwordController.text,
          ),
      progress: 'Actualizando contraseña...',
    );
    if (ok && mounted) {
      context.go(
        AppRoutes.login,
        extra: 'Contraseña actualizada. Inicia sesión con la nueva.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Recuperar contraseña',
            textAlign: TextAlign.center,
            style: AppTextStyles.title,
          ),
          const SizedBox(height: 24),
          _StepPanel(
            step: 1,
            current: _step,
            child: Form(
              key: _emailKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Ingresa tu correo registrado.',
                    style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  PixelTextField(
                    label: 'Correo electrónico',
                    controller: _emailController,
                    enabled: _step == 1 && !busy,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.email],
                    validator: Validators.email,
                    onFieldSubmitted: (_) => _sendCode(),
                  ),
                  const SizedBox(height: 16),
                  PixelButton(
                    label: 'Enviar código',
                    isLoading: busy && _step == 1,
                    onPressed: busy ? null : _sendCode,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _StepPanel(
            step: 2,
            current: _step,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Código enviado. Revisa tu correo e ingresa los 6 dígitos.',
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                PixelOtpField(
                  controller: _codeController,
                  enabled: _step == 2 && !busy,
                  hasError: _codeError,
                  onCompleted: _verifyCode,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: PixelLink(
                    label: 'Reenviar código',
                    onPressed: busy ? null : _sendCode,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _StepPanel(
            step: 3,
            current: _step,
            child: Form(
              key: _passwordKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PixelTextField(
                    label: 'Nueva contraseña',
                    controller: _passwordController,
                    enabled: _step == 3 && !busy,
                    obscure: true,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: Validators.password,
                    onFieldSubmitted: (_) => _confirmFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),
                  PixelTextField(
                    label: 'Confirmar nueva contraseña',
                    controller: _confirmController,
                    focusNode: _confirmFocus,
                    enabled: _step == 3 && !busy,
                    obscure: true,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: (value) =>
                        Validators.confirmPassword(value, _passwordController.text),
                    onFieldSubmitted: (_) => _resetPassword(),
                  ),
                  const SizedBox(height: 16),
                  PixelButton(
                    label: 'Restablecer contraseña',
                    isLoading: busy && _step == 3,
                    onPressed: busy ? null : _resetPassword,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
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
              label: 'Volver a iniciar sesión',
              onPressed: busy ? null : () => context.go(AppRoutes.login),
            ),
          ),
        ],
      ),
    );
  }
}

/// Panel de un paso: activo (borde rojo), completado (atenuado, bloqueado)
/// o pendiente (más atenuado, bloqueado).
class _StepPanel extends StatelessWidget {
  const _StepPanel({
    required this.step,
    required this.current,
    required this.child,
  });

  final int step;
  final int current;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final active = step == current;
    final done = step < current;
    return Opacity(
      opacity: active ? 1 : (done ? 0.75 : 0.4),
      child: IgnorePointer(
        ignoring: !active,
        child: PixelPanel(
          title: 'Paso $step${done ? ' [OK]' : ''}',
          accent: active,
          child: child,
        ),
      ),
    );
  }
}
