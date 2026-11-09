import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auth_state.dart';
import '../models/sso_provider.dart';
import '../repositories/auth_repository.dart';
import '../repositories/mock_auth_repository.dart';

/// Punto único donde se elige la implementación del repositorio.
/// Con el backend: `return ApiAuthRepository(...)`.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => MockAuthRepository(),
);

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

/// Estado de sesión. Los métodos que pueden fallar relanzan el `AppFailure`
/// para que cada pantalla decida cómo mostrarlo.
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState.unknown();

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<void> restore() async {
    try {
      final user = await _repository.restoreSession();
      state = user == null
          ? const AuthState.unauthenticated()
          : AuthState.authenticated(user);
    } catch (_) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login({required String email, required String password}) async {
    final user = await _repository.login(email: email, password: password);
    state = AuthState.authenticated(user);
  }

  Future<void> loginWithProvider(SsoProvider provider) async {
    final user = await _repository.loginWithProvider(provider);
    state = AuthState.authenticated(user);
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState.unauthenticated();
  }
}
