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
import '../../../core/utils/validators.dart';
import '../../../core/widgets/lumen_logo.dart';
import '../../../core/widgets/pixel_button.dart';
import '../../../core/widgets/pixel_link.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/pixel_text_field.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/status_console.dart';
import '../models/sso_provider.dart';
import '../providers/auth_providers.dart';
import '../widgets/sso_buttons.dart';

/// SCR-02. Estructura según el sketch: título, correo, contraseña, botón
/// principal, enlaces (recuperar / crear cuenta) y acceso con proveedores.
///
/// Flujos de salida:
/// - Éxito: el router detecta la sesión y redirige a Carga (SCR-18).
/// - Demasiados intentos: Cuenta bloqueada (SCR-19).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  bool _busy = false;
  bool _statusIsError = false;
  String _status = 'Ingresa tus credenciales para continuar.';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _setStatus(String message, {bool error = false}) {
    if (!mounted) return;
    setState(() {
      _status = message;
      _statusIsError = error;
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      _setStatus('Corrige los campos marcados para continuar.', error: true);
      return;
    }
    await _run(
      () => ref.read(authControllerProvider.notifier).login(
            email: _emailController.text,
            password: _passwordController.text,
          ),
    );
  }

  Future<void> _loginWith(SsoProvider provider) {
    return _run(
      () => ref.read(authControllerProvider.notifier).loginWithProvider(provider),
    );
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _status = 'Verificando acceso...';
      _statusIsError = false;
    });
    try {
      await action();
    } on AccountLockedFailure {
      if (mounted) context.go(AppRoutes.lock);
    } on InvalidCredentialsFailure catch (e) {
      _setStatus('${e.message} Intentos restantes: ${e.attemptsLeft}.', error: true);
    } on AppFailure catch (e) {
      _setStatus(e.message, error: true);
    } catch (_) {
      _setStatus('Algo salió mal. Inténtalo de nuevo.', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: LumenLogo(fontSize: 52)),
          const SizedBox(height: 6),
          Text(
            'Acceso a tu cuenta',
            textAlign: TextAlign.center,
            style: AppTextStyles.heading.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 28),
          PixelPanel(
            title: 'Iniciar sesión',
            child: AutofillGroup(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PixelTextField(
                      label: 'Correo electrónico',
                      controller: _emailController,
                      enabled: !_busy,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      validator: Validators.email,
                      onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                    ),
                    const SizedBox(height: 16),
                    PixelTextField(
                      label: 'Contraseña',
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      enabled: !_busy,
                      obscure: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      validator: Validators.password,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 20),
                    PixelButton(
                      label: 'Iniciar sesión',
                      isLoading: _busy,
                      onPressed: _busy ? null : _submit,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 12,
                      children: [
                        PixelLink(
                          label: '¿Olvidaste tu contraseña?',
                          onPressed: _busy ? null : () => context.go(AppRoutes.recovery),
                        ),
                        PixelLink(
                          label: 'Crear cuenta',
                          onPressed: _busy ? null : () => context.go(AppRoutes.register),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SsoButtons(onSelected: _busy ? null : _loginWith),
          const SizedBox(height: 24),
          StatusConsole(message: _status, isError: _statusIsError),
          if (kDebugMode) ...[
            const SizedBox(height: 10),
            Text(
              'Demo: ${MockData.demoEmail} / ${MockData.demoPassword}',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
          ],
        ],
      ),
    );
  }
}
