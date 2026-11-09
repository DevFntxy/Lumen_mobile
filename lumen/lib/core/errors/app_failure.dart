/// Errores esperables de la app. Los repositorios los lanzan y la UI los
/// traduce a mensajes. Cuando exista el backend, se mapean desde las
/// respuestas HTTP sin tocar las pantallas.
sealed class AppFailure implements Exception {
  const AppFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

class InvalidCredentialsFailure extends AppFailure {
  const InvalidCredentialsFailure({required this.attemptsLeft})
      : super('Correo o contraseña incorrectos.');

  final int attemptsLeft;
}

class AccountLockedFailure extends AppFailure {
  const AccountLockedFailure()
      : super('Cuenta bloqueada por demasiados intentos fallidos.');
}

class NetworkFailure extends AppFailure {
  const NetworkFailure()
      : super('Sin conexión. Revisa tu red e inténtalo de nuevo.');
}

class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = 'Algo salió mal. Inténtalo de nuevo.']);
}
