/// Configuración global. Todo lo que cambie entre desarrollo y producción
/// (o entre mock y backend real) vive aquí.
abstract final class AppConfig {
  static const String appName = 'LUMEN';
  static const String version = '0.1.0';

  /// Efecto de líneas de escaneo sobre toda la app.
  static const bool crtEffect = true;

  /// Intentos de login fallidos antes de bloquear la cuenta (SCR-19).
  static const int maxLoginAttempts = 5;

  /// Latencia artificial de los repositorios mock.
  static const Duration mockLatency = Duration(milliseconds: 700);

  /// Se usará cuando exista el backend.
  static const String apiBaseUrl = 'http://localhost:8000';
}
