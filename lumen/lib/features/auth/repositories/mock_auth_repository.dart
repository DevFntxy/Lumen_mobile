import '../../../app/config/app_config.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/mock/mock_data.dart';
import '../models/auth_user.dart';
import '../models/sso_provider.dart';
import 'auth_repository.dart';

/// Implementación simulada: cuentas y sesión en memoria, con bloqueo tras
/// [AppConfig.maxLoginAttempts] intentos fallidos.
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
  final Map<String, AuthUser> _usersByEmail = {
    MockData.demoEmail: _demoUser,
  };
  final Map<String, String> _passwordsByEmail = {
    MockData.demoEmail: MockData.demoPassword,
  };

  final Duration _latency;

  Future<void> _wait() => Future<void>.delayed(_latency);

  String _normalizeEmail(String email) => email.trim().toLowerCase();

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

    final normalizedEmail = _normalizeEmail(email);
    final user = _usersByEmail[normalizedEmail];
    final valid = user != null && _passwordsByEmail[normalizedEmail] == password;

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
    _session = user;
    return user;
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
    final normalizedEmail = _normalizeEmail(email);
    if (_usersByEmail.containsKey(normalizedEmail)) {
      throw const EmailInUseFailure();
    }

    final user = AuthUser(
      id: 'usr_${normalizedEmail.hashCode.abs()}',
      email: normalizedEmail,
      displayName: username.trim(),
    );
    _usersByEmail[normalizedEmail] = user;
    _passwordsByEmail[normalizedEmail] = password;
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
    _passwordsByEmail[_normalizeEmail(email)] = newPassword;
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

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _wait();
    final user = _session;
    if (user == null) {
      throw const UnknownFailure('Inicia sesión para cambiar tu contraseña.');
    }

    final email = _normalizeEmail(user.email);
    if (_passwordsByEmail[email] != currentPassword) {
      throw const InvalidCurrentPasswordFailure();
    }
    if (newPassword.trim().length < 8) {
      throw const UnknownFailure('La contraseña debe tener al menos 8 caracteres.');
    }
    _passwordsByEmail[email] = newPassword;
  }
}
