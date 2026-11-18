import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

extension AppNavigation on BuildContext {
  /// Vuelve a la pantalla anterior; si no hay (por ejemplo, tras un enlace
  /// directo), va a [fallbackPath].
  void backOr(String fallbackPath) {
    final router = GoRouter.of(this);
    if (router.canPop()) {
      router.pop();
    } else {
      router.go(fallbackPath);
    }
  }
}
