import '../../../app/config/app_config.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/mock/mock_data.dart';
import '../models/auth_user.dart';
import '../models/sso_provider.dart';
import 'auth_repository.dart';

/// Implementación simulada: una sola cuenta de demostración, sesión en
/// memoria y bloqueo tras [AppConfig.maxLoginAttempts] intentos fallidos.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository({Duration? latency})
      : _latency = latency ?? AppConfig.mockLatency;

  static const AuthUser _demoUser = AuthUser(
    id: MockData.demoUserId,
    email: MockData.demoEmail,
    displayName: MockData.demoDisplayName,
  );

  AuthUser? _session;
  int _failedAttempts = 0;
  bool _locked = false;

  final Duration _latency;

  Future<void> _wait() => Future<void>.delayed(_latency);

  bool _isDemoEmail(String email) =>
      email.trim().toLowerCase() == MockData.demoEmail;

  @override
  Future<AuthUser?> restoreSession() async {
    await _wait();
    return _session;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    await _wait();
    if (_locked) throw const AccountLockedFailure();

    final valid = _isDemoEmail(email) && password == MockData.demoPassword;

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
    await _wait();
    _session = _demoUser;
    return _demoUser;
  }

  @override
  Future<AuthUser> register({
    required String username,
    required String email,
    required String password,
  }) async {
    await _wait();
    if (_isDemoEmail(email)) throw const EmailInUseFailure();

    final user = AuthUser(
      id: 'usr_${email.trim().toLowerCase().hashCode.abs()}',
      email: email.trim().toLowerCase(),
      displayName: username.trim(),
    );
    _session = user;
    return user;
  }

  @override
  Future<void> logout() async {
    _session = null;
  }

  /// En el mock solo cierra la sesión; la cuenta demo se conserva.
  @override
  Future<void> deleteAccount() async {
    await _wait();
    _session = null;
  }

  @override
  Future<void> requestPasswordReset(String email) => _wait();

  @override
  Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {
    await _wait();
    if (code != MockData.demoOtp) throw const InvalidCodeFailure();
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _wait();
    if (code != MockData.demoOtp) throw const InvalidCodeFailure();
  }

  @override
  Future<void> requestUnlockCode() => _wait();

  @override
  Future<void> unlockAccount(String code) async {
    await _wait();
    if (code != MockData.demoOtp) throw const InvalidCodeFailure();
    _locked = false;
    _failedAttempts = 0;
  }
}
