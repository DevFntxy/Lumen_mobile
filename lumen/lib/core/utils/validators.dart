/// Validadores de formularios. Devuelven `null` si el valor es válido o el
/// mensaje de error en caso contrario (formato que espera `TextFormField`).
abstract final class Validators {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp _usernamePattern = RegExp(r'^[A-Za-z0-9_-]+$');

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Escribe tu correo electrónico.';
    if (!_emailPattern.hasMatch(text)) {
      return 'Revisa el formato: nombre@dominio.com.';
    }
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Escribe tu contraseña.';
    if (text.length < 8) return 'Usa al menos 8 caracteres.';
    return null;
  }

  static String? username(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Elige un nombre de usuario.';
    if (text.length < 3 || text.length > 20) {
      return 'Usa entre 3 y 20 caracteres.';
    }
    if (!_usernamePattern.hasMatch(text)) {
      return 'Solo letras, números, guion y guion bajo.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if ((value ?? '').isEmpty) return 'Repite tu contraseña.';
    if (value != original) return 'Las contraseñas no coinciden.';
    return null;
  }
}
