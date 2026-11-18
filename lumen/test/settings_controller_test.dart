import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore_for_file: avoid_relative_lib_imports
import '../lib/features/settings/providers/settings_providers.dart';
import '../lib/features/settings/models/app_settings.dart';
import '../lib/features/settings/repositories/mock_settings_repository.dart';

void main() {
  test('guarda y vuelve a exponer las preferencias modificadas', () async {
    final container = ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWith(
          (ref) => MockSettingsRepository(latency: Duration.zero),
        ),
      ],
    );
    addTearDown(container.dispose);

    final controller = container.read(settingsControllerProvider.notifier);
    await controller.updateAndSave(
      (settings) => settings.copyWith(crtEnabled: false),
    );

    expect(container.read(settingsControllerProvider).crtEnabled, isFalse);
    expect(
      await container.read(settingsRepositoryProvider).load().then(
            (settings) => settings.crtEnabled,
          ),
      isFalse,
    );
  });

  test('revierte el volumen en memoria si no puede guardarlo', () async {
    final repository = _FailingSettingsRepository();
    final container = ProviderContainer(
      overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    final controller = container.read(settingsControllerProvider.notifier);

    controller.previewVolume(0.2);
    await expectLater(controller.saveVolume(), throwsStateError);

    expect(container.read(settingsControllerProvider).soundVolume, 0.7);
  });
}

class _FailingSettingsRepository extends MockSettingsRepository {
  @override
  Future<void> save(AppSettings settings) =>
      Future<void>.error(StateError('write failed'));
}
