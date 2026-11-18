import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/app_failure.dart';
import 'state_views.dart';

/// Muestra los tres estados de un `AsyncValue` (cargando, error, datos) con
/// los widgets estándar de la app.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.loadingMessage = 'Cargando...',
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final String loadingMessage;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => LoadingState(message: loadingMessage),
      error: (error, stackTrace) => ErrorState(
        message: error is AppFailure
            ? error.message
            : 'No pudimos cargar tus datos. Inténtalo de nuevo.',
        onRetry: onRetry,
      ),
    );
  }
}
