import 'package:flutter_test/flutter_test.dart';

// Import relativo a propósito: funciona sin conocer el nombre del paquete.
// ignore: avoid_relative_lib_imports
import '../lib/core/utils/formatters.dart';

void main() {
  test('formatDate usa dd/MM/yyyy con ceros', () {
    expect(formatDate(DateTime(2026, 1, 5)), '05/01/2026');
  });

  test('formatDateTime agrega hora y minutos de dos dígitos', () {
    expect(formatDateTime(DateTime(2026, 10, 30, 8, 7)), '30/10/2026 08:07');
  });

  test('formatPercent redondea', () {
    expect(formatPercent(0.38), '38%');
    expect(formatPercent(0.655), '66%');
    expect(formatPercent(1), '100%');
  });
}
