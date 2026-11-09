/// Validadores de formularios. Devuelven `null` si el valor es válido o el
/// mensaje de error en caso contrario (formato que espera `TextFormField`).
abstract final class Validators {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

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
}
