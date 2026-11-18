import 'package:flutter/widgets.dart';

import '../errors/app_failure.dart';

/// Estado compartido por las pantallas con formularios que llaman a un
/// repositorio: indicador de carga + mensaje para la `StatusConsole`.
///
/// Uso: `await runGuarded(() => repo.algo(), progress: 'Enviando...')`.
/// Devuelve `true` si terminó sin error. Los `AppFailure` se muestran en la
/// consola de estado, salvo que [onFailure] los maneje y devuelva `true`.
mixin AsyncFormMixin<T extends StatefulWidget> on State<T> {
  bool busy = false;
  bool statusIsError = false;
  String status = '';

  void setStatus(String message, {bool error = false}) {
    if (!mounted) return;
    setState(() {
      status = message;
      statusIsError = error;
    });
  }

  Future<bool> runGuarded(
    Future<void> Function() action, {
    String? progress,
    bool Function(AppFailure failure)? onFailure,
  }) async {
    setState(() {
      busy = true;
      statusIsError = false;
      if (progress != null) status = progress;
    });
    try {
      await action();
      return true;
    } on AppFailure catch (failure) {
      final handled = onFailure?.call(failure) ?? false;
      if (!handled) setStatus(failure.message, error: true);
      return false;
    } catch (_) {
      setStatus('Algo salió mal. Inténtalo de nuevo.', error: true);
      return false;
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }
}
