import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/async_form_mixin.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/pixel_button.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/pixel_text_field.dart';
import '../../../core/widgets/status_console.dart';
import '../../auth/providers/auth_providers.dart';

Future<void> showChangePasswordSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ChangePasswordSheet(),
    );

class _ChangePasswordSheet extends ConsumerStatefulWidget {
  const _ChangePasswordSheet();

  @override
  ConsumerState<_ChangePasswordSheet> createState() =>
      _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends ConsumerState<_ChangePasswordSheet>
    with AsyncFormMixin<_ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final updated = await runGuarded(
      () => ref.read(authRepositoryProvider).changePassword(
            currentPassword: _currentController.text,
            newPassword: _newController.text,
          ),
      progress: 'Actualizando contraseña...',
    );
    if (updated && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottom),
        child: PixelPanel(
          title: 'Cambiar contraseña',
          accent: true,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Elige una contraseña de al menos 8 caracteres.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 14),
                PixelTextField(
                  label: 'Contraseña actual',
                  controller: _currentController,
                  obscure: true,
                  validator: Validators.password,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                PixelTextField(
                  label: 'Nueva contraseña',
                  controller: _newController,
                  obscure: true,
                  validator: Validators.password,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                PixelTextField(
                  label: 'Confirmar contraseña',
                  controller: _confirmController,
                  obscure: true,
                  validator: (value) =>
                      Validators.confirmPassword(value, _newController.text),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                ),
                if (status.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  StatusConsole(message: status, isError: statusIsError),
                ],
                const SizedBox(height: 14),
                PixelButton(
                  label: 'Actualizar contraseña',
                  onPressed: busy ? null : _submit,
                  isLoading: busy,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
