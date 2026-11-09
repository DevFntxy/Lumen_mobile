import '../../../app/config/app_config.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/mock/mock_data.dart';
import '../models/auth_user.dart';
import '../models/sso_provider.dart';
import 'auth_repository.dart';

/// Implementación simulada: una sola cuenta de demostración, sesión en
/// memoria y bloqueo tras [AppConfig.maxLoginAttempts] intentos fallidos.
class MockAuthRepository implements AuthRepository {
  static const AuthUser _demoUser = AuthUser(
    id: MockData.demoUserId,
    email: MockData.demoEmail,
    displayName: MockData.demoDisplayName,
  );

  AuthUser? _session;
  int _failedAttempts = 0;
  bool _locked = false;

  Future<void> _latency() => Future<void>.delayed(AppConfig.mockLatency);

  @override
  Future<AuthUser?> restoreSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _session;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    await _latency();
    if (_locked) throw const AccountLockedFailure();

    final valid = email.trim().toLowerCase() == MockData.demoEmail &&
        password == MockData.demoPassword;

    if (!valid) {
      _failedAttempts++;
      if (_failedAttempts >= AppConfig.maxLoginAttempts) {
        _locked = true;
        throw const AccountLockedFailure();
      }
      throw InvalidCredentialsFailure(
        attemptsLeft: AppConfig.maxLoginAttempts - _failedAttempts,
      );
    }

    _failedAttempts = 0;
    _session = _demoUser;
    return _demoUser;
  }

  @override
  Future<AuthUser> loginWithProvider(SsoProvider provider) async {
    await _latency();
    _session = _demoUser;
    return _demoUser;
  }

  @override
  Future<void> logout() async {
    _session = null;
  }
}
