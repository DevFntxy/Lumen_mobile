import 'package:flutter_test/flutter_test.dart';

// ignore_for_file: avoid_relative_lib_imports
import '../lib/app/router/screen_catalog.dart';

void main() {
  test('las 22 pantallas del diagrama están implementadas', () {
    expect(ScreenCatalog.all, hasLength(22));
    expect(ScreenCatalog.pending, isEmpty);
  });
}
