import '../models/auth_user.dart';
import '../models/sso_provider.dart';

/// Contrato de acceso a cuentas. Hoy lo implementa [MockAuthRepository];
/// con el backend se agrega una implementación HTTP y se cambia el provider
/// en auth_providers.dart, sin tocar pantallas.
///
/// Los errores esperables se lanzan como `AppFailure`.
abstract interface class AuthRepository {
  /// Devuelve el usuario de la sesión guardada o `null` si no hay.
  Future<AuthUser?> restoreSession();

  Future<AuthUser> login({required String email, required String password});

  Future<AuthUser> loginWithProvider(SsoProvider provider);

  Future<AuthUser> register({
    required String username,
    required String email,
    required String password,
  });

  Future<void> logout();

  /// Elimina la cuenta de la sesión activa.
  Future<void> deleteAccount();

  // Recuperación de contraseña.
  Future<void> requestPasswordReset(String email);

  Future<void> verifyResetCode({required String email, required String code});

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  // Desbloqueo de cuenta.
  Future<void> requestUnlockCode();

  Future<void> unlockAccount(String code);
}
