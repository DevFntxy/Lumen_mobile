import '../../../app/config/app_config.dart';
import '../models/app_settings.dart';
import 'settings_repository.dart';

class MockSettingsRepository implements SettingsRepository {
  MockSettingsRepository({Duration? latency})
      : _latency = latency ?? AppConfig.mockLatency;

  final Duration _latency;
  AppSettings _settings = AppSettings.defaults();

  Future<void> _wait() => Future<void>.delayed(_latency);

  @override
  Future<AppSettings> load() async {
    await _wait();
    return _settings;
  }

  @override
  Future<void> save(AppSettings settings) async {
    await _wait();
    _settings = settings;
  }
}
