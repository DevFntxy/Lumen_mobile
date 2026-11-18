import 'package:flutter_test/flutter_test.dart';

// Imports relativos a propósito: funcionan sin conocer el nombre del paquete.
// ignore_for_file: avoid_relative_lib_imports
import '../lib/app/config/app_config.dart';
import '../lib/core/errors/app_failure.dart';
import '../lib/core/mock/mock_data.dart';
import '../lib/features/auth/repositories/mock_auth_repository.dart';

void main() {
  late MockAuthRepository repo;

  setUp(() => repo = MockAuthRepository(latency: Duration.zero));

  Future<void> failLogin() =>
      repo.login(email: MockData.demoEmail, password: 'incorrecta1');

  test('login correcto devuelve el usuario y deja sesión', () async {
    final user = await repo.login(
      email: MockData.demoEmail,
      password: MockData.demoPassword,
    );
    expect(user.email, MockData.demoEmail);
    expect(await repo.restoreSession(), isNotNull);
  });

  test('credenciales incorrectas informan los intentos restantes', () async {
    try {
      await failLogin();
      fail('debía lanzar');
    } on InvalidCredentialsFailure catch (e) {
      expect(e.attemptsLeft, AppConfig.maxLoginAttempts - 1);
    }
  });

  test(
    'bloquea tras maxLoginAttempts, incluso con la clave correcta',
    () async {
      for (var i = 1; i < AppConfig.maxLoginAttempts; i++) {
        await expectLater(
          failLogin(),
          throwsA(isA<InvalidCredentialsFailure>()),
        );
      }
      await expectLater(failLogin(), throwsA(isA<AccountLockedFailure>()));
      await expectLater(
        repo.login(email: MockData.demoEmail, password: MockData.demoPassword),
        throwsA(isA<AccountLockedFailure>()),
      );
    },
  );

  test('desbloqueo con código válido permite volver a entrar', () async {
    for (var i = 0; i < AppConfig.maxLoginAttempts; i++) {
      try {
        await failLogin();
      } on AppFailure {
        // esperado
      }
    }
    await repo.unlockAccount(MockData.demoOtp);
    final user = await repo.login(
      email: MockData.demoEmail,
      password: MockData.demoPassword,
    );
    expect(user.id, MockData.demoUserId);
  });

  test('código de desbloqueo o recuperación inválido falla', () async {
    await expectLater(
      repo.unlockAccount('000000'),
      throwsA(isA<InvalidCodeFailure>()),
    );
    await expectLater(
      repo.verifyResetCode(email: MockData.demoEmail, code: '000000'),
      throwsA(isA<InvalidCodeFailure>()),
    );
    await repo.verifyResetCode(
      email: MockData.demoEmail,
      code: MockData.demoOtp,
    );
  });

  test('registro con un correo existente falla', () async {
    await expectLater(
      repo.register(
        username: 'otro',
        email: MockData.demoEmail,
        password: 'Lumen2026',
      ),
      throwsA(isA<EmailInUseFailure>()),
    );
  });

  test('registro nuevo crea la sesión con el nombre elegido', () async {
    final user = await repo.register(
      username: 'Jugador_1',
      email: 'nuevo@lumen.dev',
      password: 'Lumen2026',
    );
    expect(user.displayName, 'Jugador_1');
    expect((await repo.restoreSession())?.email, 'nuevo@lumen.dev');
  });

  test(
    'cambiar contraseña verifica la actual y permite volver a entrar',
    () async {
      await repo.login(
        email: MockData.demoEmail,
        password: MockData.demoPassword,
      );
      await expectLater(
        repo.changePassword(
          currentPassword: 'contraseña-incorrecta',
          newPassword: 'NuevaClave2026',
        ),
        throwsA(isA<InvalidCurrentPasswordFailure>()),
      );

      await repo.changePassword(
        currentPassword: MockData.demoPassword,
        newPassword: 'NuevaClave2026',
      );
      await repo.logout();
      await expectLater(
        repo.login(email: MockData.demoEmail, password: MockData.demoPassword),
        throwsA(isA<InvalidCredentialsFailure>()),
      );
      final user = await repo.login(
        email: MockData.demoEmail,
        password: 'NuevaClave2026',
      );
      expect(user.email, MockData.demoEmail);
    },
  );

  test('eliminar la cuenta cierra la sesión', () async {
    await repo.login(
      email: MockData.demoEmail,
      password: MockData.demoPassword,
    );
    await repo.deleteAccount();
    expect(await repo.restoreSession(), isNull);
  });
}
