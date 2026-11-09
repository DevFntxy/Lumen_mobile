import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config/app_config.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/lumen_logo.dart';
import '../../../core/widgets/pixel_loading_dots.dart';
import '../models/auth_state.dart';
import '../providers/auth_providers.dart';

/// SCR-01. Comprueba la sesión guardada y decide el destino:
/// con sesión → Carga (SCR-18); sin sesión → Login (SCR-02).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const Duration _minimumDuration = Duration(milliseconds: 2200);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _boot());
  }

  Future<void> _boot() async {
    final controller = ref.read(authControllerProvider.notifier);
    await Future.wait<void>([
      controller.restore(),
      Future<void>.delayed(_minimumDuration),
    ]);
    if (!mounted) return;
    final authenticated =
        ref.read(authControllerProvider).status == AuthStatus.authenticated;
    context.go(authenticated ? AppRoutes.loading : AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 3),
                const Center(child: LumenLogo(fontSize: 64)),
                const SizedBox(height: 12),
                Text(
                  'Crónicas de una ciudad olvidada',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                ),
                const Spacer(flex: 2),
                const Center(child: PixelLoadingDots(size: 14)),
                const SizedBox(height: 16),
                const Text(
                  'Iniciando secuencia de carga...',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.label,
                ),
                const Spacer(),
                Text('Versión ${AppConfig.version}', style: AppTextStyles.caption),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
