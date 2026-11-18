/// Datos simulados centralizados. Se eliminan cuando exista el backend.
abstract final class MockData {
  // Cuenta de demostración para probar el login.
  static const String demoUserId = 'usr_0001';
  static const String demoEmail = 'm4@lumen.dev';
  static const String demoPassword = 'Lumen2026';
  static const String demoDisplayName = 'M-4';

  // Jugador de demostración (el resto de cuentas empieza sin partida).
  static const String demoAvatarId = 'm4';
  static const String demoActName = 'Acto II: Fábrica hundida';
  static const double demoActProgress = 0.65;
  static const double demoOverallCompletion = 0.38;
  static const int demoZonesUnlocked = 2;
  static const int demoZonesTotal = 5;
  static const int demoActiveQuests = 4;
  static const int demoCodexUnlocked = 5;
  static const int demoCodexTotal = 12;
  static const int demoAchievementsUnlocked = 7;
  static const int demoAchievementsTotal = 24;
  static final DateTime demoLastSession = DateTime(2026, 10, 30, 18, 42);
  static final DateTime demoAccountCreated = DateTime(2026, 10, 13, 9, 15);
  static const String demoGoogleAccount = 'm4.lumen@gmail.com';
  static const String demoGithubAccount = 'm4-unit';

  // Código de 6 dígitos válido para recuperación y desbloqueo.
  static const String demoOtp = '123456';
}
