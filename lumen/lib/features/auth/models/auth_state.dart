import 'auth_user.dart';

enum AuthStatus {
  /// Aún no se ha comprobado si hay una sesión guardada.
  unknown,
  unauthenticated,
  authenticated,
}

class AuthState {
  const AuthState._(this.status, this.user);

  const AuthState.unknown() : this._(AuthStatus.unknown, null);

  const AuthState.unauthenticated() : this._(AuthStatus.unauthenticated, null);

  const AuthState.authenticated(AuthUser user)
      : this._(AuthStatus.authenticated, user);

  final AuthStatus status;
  final AuthUser? user;
}
