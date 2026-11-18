import 'package:flutter/material.dart';

import 'app_background.dart';

/// Contenedor estándar de pantallas con formulario o contenido centrado:
/// fondo, zona segura, scroll (para teclado y pantallas pequeñas) y ancho
/// máximo para tablets.
class ScreenScaffold extends StatelessWidget {
  const ScreenScaffold({
    super.key,
    required this.child,
    this.maxWidth = 440,
    this.centered = true,
  });

  final Widget child;
  final double maxWidth;

  /// `true` centra el contenido verticalmente (formularios, estados);
  /// `false` lo alinea arriba (pantallas con cabecera y listas).
  final bool centered;

  static const double _padding = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final minHeight = constraints.maxHeight > _padding * 2
                  ? constraints.maxHeight - _padding * 2
                  : 0.0;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(_padding),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: minHeight),
                  child: centered
                      ? Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxWidth),
                            child: child,
                          ),
                        )
                      : Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxWidth),
                            child: child,
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
