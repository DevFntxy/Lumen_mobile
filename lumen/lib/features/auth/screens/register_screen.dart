import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show AutofillHints;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/async_form_mixin.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/lumen_logo.dart';
import '../../../core/widgets/pixel_button.dart';
import '../../../core/widgets/pixel_checkbox.dart';
import '../../../core/widgets/pixel_dialog.dart';
import '../../../core/widgets/pixel_link.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/pixel_text_field.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/status_console.dart';
import '../models/sso_provider.dart';
import '../providers/auth_providers.dart';
import '../widgets/sso_buttons.dart';

/// SCR-03. Usuario, correo, contraseña con confirmación, aceptación de
/// términos y registro con proveedores.
///
/// Flujos de salida:
/// - Éxito: el router detecta la sesión y redirige a Carga (SCR-18).
/// - "Inicia sesión": Login (SCR-02).
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with AsyncFormMixin<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    status = 'Completa los datos para crear tu cuenta.';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      setStatus('Corrige los campos marcados para continuar.', error: true);
      return;
    }
    await runGuarded(
      () => ref.read(authControllerProvider.notifier).register(
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
      progress: 'Creando cuenta...',
    );
  }

  Future<void> _registerWith(SsoProvider provider) {
    return runGuarded(
      () => ref.read(authControllerProvider.notifier).loginWithProvider(provider),
      progress: 'Conectando con ${provider.label}...',
    );
  }

  void _showTerms() {
    showPixelDialog(
      context: context,
      title: 'Términos y condiciones',
      message: 'Texto provisional. Aquí irán los términos de uso y la política '
          'de privacidad de LUMEN cuando el equipo los redacte.',
    );
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
            'Crear cuenta',
            textAlign: TextAlign.center,
            style: AppTextStyles.heading.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 28),
          PixelPanel(
            title: 'Registro',
            child: AutofillGroup(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PixelTextField(
                      label: 'Nombre de usuario',
                      controller: _usernameController,
                      enabled: !busy,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newUsername],
                      validator: Validators.username,
                      onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                    ),
                    const SizedBox(height: 16),
                    PixelTextField(
                      label: 'Correo electrónico',
                      controller: _emailController,
                      focusNode: _emailFocus,
                      enabled: !busy,
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
                      enabled: !busy,
                      obscure: true,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: Validators.password,
                      onFieldSubmitted: (_) => _confirmFocus.requestFocus(),
                    ),
                    const SizedBox(height: 16),
                    PixelTextField(
                      label: 'Confirmar contraseña',
                      controller: _confirmController,
                      focusNode: _confirmFocus,
                      enabled: !busy,
                      obscure: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: (value) =>
                          Validators.confirmPassword(value, _passwordController.text),
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 16),
                    PixelCheckbox(
                      enabled: !busy,
                      validator: (accepted) => accepted == true
                          ? null
                          : 'Debes aceptar los términos y condiciones.',
                      label: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text('Acepto los ', style: AppTextStyles.body),
                          PixelLink(
                            label: 'términos y condiciones',
                            onPressed: busy ? null : _showTerms,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    PixelButton(
                      label: 'Crear cuenta',
                      isLoading: busy,
                      onPressed: busy ? null : _submit,
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: PixelLink(
                        label: '¿Ya tienes cuenta? Inicia sesión',
                        onPressed: busy ? null : () => context.go(AppRoutes.login),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SsoButtons(
            label: 'O regístrate con',
            onSelected: busy ? null : _registerWith,
          ),
          const SizedBox(height: 24),
          StatusConsole(message: status, isError: statusIsError),
        ],
      ),
    );
  }
}
