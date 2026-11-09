import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/pixel_loading_dots.dart';
import '../../../core/widgets/screen_scaffold.dart';

/// SCR-18. Transición tras el login. Hoy simula la precarga de datos y pasa
/// a Inicio (SCR-05); con el backend aquí se sincroniza el perfil del jugador.
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) context.go(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PixelLoadingDots(size: 16),
          const SizedBox(height: 20),
          const Text('Sincronizando datos de M-4...', style: AppTextStyles.heading),
        ],
      ),
    );
  }
}
