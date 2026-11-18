import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings.dart';
import '../repositories/mock_settings_repository.dart';
import '../repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => MockSettingsRepository(),
);

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

class SettingsController extends Notifier<AppSettings> {
  AppSettings _saved = AppSettings.defaults();

  SettingsRepository get _repository => ref.read(settingsRepositoryProvider);

  @override
  AppSettings build() => _saved;

  Future<void> updateAndSave(AppSettings Function(AppSettings) update) async {
    final previous = state;
    state = update(previous);
    try {
      await _repository.save(state);
      _saved = state;
    } catch (_) {
      state = previous;
      rethrow;
    }
  }

  void previewVolume(double volume) {
    state = state.copyWith(soundVolume: volume);
  }

  Future<void> saveVolume() async {
    final previous = _saved;
    try {
      await _repository.save(state);
      _saved = state;
    } catch (_) {
      state = previous;
      rethrow;
    }
  }
}
