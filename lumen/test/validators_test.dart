import 'package:flutter_test/flutter_test.dart';

// Import relativo a propósito: funciona sin conocer el nombre del paquete.
// ignore: avoid_relative_lib_imports
import '../lib/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('rechaza vacío', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
    });

    test('rechaza formato inválido', () {
      expect(Validators.email('sin-arroba'), isNotNull);
      expect(Validators.email('a@b'), isNotNull);
    });

    test('acepta correo válido', () {
      expect(Validators.email('m4@lumen.dev'), isNull);
    });
  });

  group('Validators.password', () {
    test('rechaza vacío y corto', () {
      expect(Validators.password(''), isNotNull);
      expect(Validators.password('abc123'), isNotNull);
    });

    test('acepta 8 o más caracteres', () {
      expect(Validators.password('Lumen2026'), isNull);
    });
  });
}
