import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/widgets/scanline_overlay.dart';
import 'config/app_config.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class LumenApp extends ConsumerWidget {
  const LumenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
      // El efecto CRT se aplica una sola vez, encima de todas las pantallas.
      builder: (context, child) => ScanlineOverlay(
        enabled: AppConfig.crtEffect,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
