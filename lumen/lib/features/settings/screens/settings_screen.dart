import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/navigation.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/async_form_mixin.dart';
import '../../../core/widgets/pixel_header.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/pixel_slider.dart';
import '../../../core/widgets/pixel_tile.dart';
import '../../../core/widgets/pixel_toggle.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/status_console.dart';
import '../models/app_settings.dart';
import '../providers/settings_providers.dart';
import '../widgets/change_password_sheet.dart';
import '../widgets/language_picker_sheet.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with AsyncFormMixin<SettingsScreen> {
  Future<void> _pickLanguage(AppSettings settings) async {
    final language = await showLanguagePickerSheet(
      context,
      selectedCode: settings.languageCode,
    );
    if (language == null || !mounted || language == settings.languageCode) {
      return;
    }
    await runGuarded(
      () => ref
          .read(settingsControllerProvider.notifier)
          .updateAndSave((value) => value.copyWith(languageCode: language)),
      progress: 'Guardando idioma...',
    );
  }

  Future<void> _update(
    AppSettings Function(AppSettings settings) update, {
    required String progress,
  }) => runGuarded(
    () => ref.read(settingsControllerProvider.notifier).updateAndSave(update),
    progress: progress,
  );

  void _showPrivacy() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Privacidad', style: AppTextStyles.heading),
        content: Text(
          'Esta versión demo almacena los ajustes y el progreso solo en '
          'memoria. No se envían datos a un servicio remoto.',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ENTENDIDO'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return ScreenScaffold(
      centered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PixelHeader(
            title: 'Ajustes',
            onBack: () => context.backOr(AppRoutes.home),
          ),
          const SizedBox(height: 20),
          PixelPanel(
            title: 'Preferencias',
            child: Column(
              children: [
                PixelTile(
                  title: 'Idioma',
                  subtitle: settings.languageCode == 'es'
                      ? 'Español'
                      : 'English',
                  onTap: busy ? null : () => _pickLanguage(settings),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                PixelTile(
                  title: 'Notificaciones',
                  subtitle: 'Avisos de misiones y recompensas',
                  trailing: PixelToggle(
                    semanticLabel: 'Notificaciones',
                    value: settings.notificationsEnabled,
                    onChanged: busy
                        ? null
                        : (value) => _update(
                            (current) =>
                                current.copyWith(notificationsEnabled: value),
                            progress: 'Guardando preferencia...',
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                PixelTile(
                  title: 'Efecto CRT',
                  subtitle: 'Líneas de escaneo en la interfaz',
                  trailing: PixelToggle(
                    semanticLabel: 'Efecto CRT',
                    value: settings.crtEnabled,
                    onChanged: busy
                        ? null
                        : (value) => _update(
                            (current) => current.copyWith(crtEnabled: value),
                            progress: 'Guardando preferencia...',
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                PixelTile(
                  title: 'Volumen',
                  subtitle:
                      'Efectos de sonido · ${(settings.soundVolume * 100).round()}%',
                  bottom: PixelSlider(
                    semanticLabel: 'Volumen de efectos de sonido',
                    value: settings.soundVolume,
                    onChanged: busy ? (_) {} : controller.previewVolume,
                    onChangeEnd: busy
                        ? null
                        : (_) => runGuarded(
                            controller.saveVolume,
                            progress: 'Guardando volumen...',
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          PixelPanel(
            title: 'Cuenta',
            child: Column(
              children: [
                PixelTile(
                  title: 'Cuentas vinculadas',
                  subtitle: 'Gestionar proveedores conectados',
                  onTap: () => context.push(AppRoutes.profile),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                PixelTile(
                  title: 'Cambiar contraseña',
                  subtitle: 'Actualiza la contraseña de tu cuenta',
                  onTap: busy ? null : () => showChangePasswordSheet(context),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                PixelTile(
                  title: 'Privacidad',
                  subtitle: 'Información sobre tus datos',
                  onTap: _showPrivacy,
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          PixelPanel(
            title: 'Acerca de',
            child: Column(
              children: [
                PixelTile(
                  title: 'Acerca del software',
                  subtitle: 'Versión y características',
                  onTap: () => context.push(AppRoutes.aboutSoftware),
                ),
                const SizedBox(height: 10),
                PixelTile(
                  title: 'Acerca del equipo',
                  subtitle: 'Conoce al equipo de LUMEN',
                  onTap: () => context.push(AppRoutes.aboutTeam),
                ),
              ],
            ),
          ),
          if (status.isNotEmpty) ...[
            const SizedBox(height: 16),
            StatusConsole(message: status, isError: statusIsError),
          ],
        ],
      ),
    );
  }
}
