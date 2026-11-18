import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/navigation.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/pixel_header.dart';
import '../../../core/widgets/pixel_nav_card.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/pixel_progress_bar.dart';
import '../../../core/widgets/pixel_tile.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../player/models/player_progress.dart';
import '../../player/providers/player_providers.dart';

class ZoneMapScreen extends ConsumerWidget {
  const ZoneMapScreen({super.key});

  static const _zones = [
    _ZoneInfo('Sector G', 'Fundición', 'Zona inicial de la ciudad.'),
    _ZoneInfo('Dársena 04', 'Fábrica inundada', 'Pasajes industriales anegados.'),
    _ZoneInfo('Núcleo central', 'Zona de energía', 'Centro de control de LUMEN.'),
    _ZoneInfo('Jardín metálico', 'Zona exterior', 'Antiguo corredor de mantenimiento.'),
    _ZoneInfo('Distrito cero', 'Último sector', 'El origen de la señal.'),
  ];

  Future<void> _showZone(BuildContext context, _ZoneInfo zone, bool unlocked) =>
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.surface,
        builder: (context) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(zone.name, style: AppTextStyles.heading),
                const SizedBox(height: 4),
                Text(zone.subtitle, style: AppTextStyles.caption),
                const SizedBox(height: 12),
                Text(
                  unlocked
                      ? zone.description
                      : 'Esta zona está bloqueada. Continúa la partida para '
                          'desbloquear el acceso.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CERRAR'),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _content(BuildContext context, PlayerProgress progress) {
    final unlocked = progress.zonesUnlocked.clamp(0, _zones.length);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PixelPanel(
          title: 'Progreso de zona',
          accent: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${progress.zonesUnlocked} / ${progress.zonesTotal} zonas abiertas',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 10),
              PixelProgressBar(
                value: progress.zonesTotal == 0
                    ? 0
                    : progress.zonesUnlocked / progress.zonesTotal,
                segments: 10,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PixelPanel(
          title: progress.actName,
          child: Column(
            children: [
              SizedBox(
                height: 286,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _ZoneRoutePainter(),
                          ),
                        ),
                        _positionedZone(
                          width,
                          0.02,
                          0.09,
                          _zones[0],
                          unlocked > 0,
                          () => _showZone(context, _zones[0], unlocked > 0),
                        ),
                        _positionedZone(
                          width,
                          0.02,
                          0.65,
                          _zones[1],
                          unlocked > 1,
                          () => _showZone(context, _zones[1], unlocked > 1),
                        ),
                        _positionedZone(
                          width,
                          0.29,
                          0.39,
                          _zones[2],
                          unlocked > 2,
                          () => _showZone(context, _zones[2], unlocked > 2),
                        ),
                        _positionedZone(
                          width,
                          0.58,
                          0.09,
                          _zones[3],
                          unlocked > 3,
                          () => _showZone(context, _zones[3], unlocked > 3),
                        ),
                        _positionedZone(
                          width,
                          0.58,
                          0.65,
                          _zones[4],
                          unlocked > 4,
                          () => _showZone(context, _zones[4], unlocked > 4),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              PixelProgressBar(value: progress.actProgress, segments: 10),
              const SizedBox(height: 6),
              Text(
                'Acto ${(progress.actProgress * 100).round()}% completado',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text('ZONAS DE JEFE', style: AppTextStyles.label),
        const SizedBox(height: 8),
        PixelTile(
          title: 'Jardín metálico',
          subtitle: 'Jefe: El Jardinero',
          leading: const Icon(Icons.warning_amber, color: AppColors.primaryLight),
          trailing: Icon(
            unlocked > 3 ? Icons.check_circle_outline : Icons.lock_outline,
            color: AppColors.textSecondary,
          ),
          onTap: () => _showZone(context, _zones[3], unlocked > 3),
        ),
        const SizedBox(height: 8),
        PixelTile(
          title: 'Distrito cero',
          subtitle: 'Jefe: El Conductor',
          leading: const Icon(Icons.warning_amber, color: AppColors.primaryLight),
          trailing: Icon(
            unlocked > 4 ? Icons.check_circle_outline : Icons.lock_outline,
            color: AppColors.textSecondary,
          ),
          onTap: () => _showZone(context, _zones[4], unlocked > 4),
        ),
        const SizedBox(height: 18),
        PixelNavCard(
          title: 'Misiones activas',
          subtitle: 'Consulta tus objetivos en curso',
          onTap: () => context.push(AppRoutes.quests),
        ),
        const SizedBox(height: 10),
        PixelNavCard(
          title: 'Progreso de partida',
          subtitle: 'Ver el resumen de tu aventura',
          onTap: () => context.push(AppRoutes.progress),
        ),
      ],
    );
  }

  Widget _positionedZone(
    double width,
    double leftFactor,
    double topFactor,
    _ZoneInfo zone,
    bool unlocked,
    VoidCallback onTap,
  ) {
    final nodeWidth = width * 0.40;
    return Positioned(
      left: width * leftFactor,
      top: 286 * topFactor,
      width: nodeWidth,
      child: _ZoneNode(
        zone: zone,
        unlocked: unlocked,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(playerProgressProvider);
    return ScreenScaffold(
      centered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PixelHeader(
            title: 'Mapa de zonas',
            onBack: () => context.backOr(AppRoutes.progress),
          ),
          const SizedBox(height: 18),
          AsyncValueView<PlayerProgress?>(
            value: progress,
            loadingMessage: 'Cartografiando sectores...',
            onRetry: () => ref.invalidate(playerProgressProvider),
            data: (data) => data == null
                ? const PixelPanel(
                    title: 'Sin partida',
                    child: Text(
                      'Inicia una partida para consultar el mapa de zonas.',
                      style: AppTextStyles.body,
                    ),
                  )
                : _content(context, data),
          ),
        ],
      ),
    );
  }
}

class _ZoneInfo {
  const _ZoneInfo(this.name, this.subtitle, this.description);

  final String name;
  final String subtitle;
  final String description;
}

class _ZoneNode extends StatelessWidget {
  const _ZoneNode({
    required this.zone,
    required this.unlocked,
    required this.onTap,
  });

  final _ZoneInfo zone;
  final bool unlocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${zone.name}, ${unlocked ? 'desbloqueada' : 'bloqueada'}',
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: 66,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: unlocked ? AppColors.primaryDark : AppColors.surfaceRaised,
            border: Border.all(
              color: unlocked ? AppColors.primaryLight : AppColors.metal,
              width: 3,
            ),
          ),
          child: Row(
            children: [
              Icon(
                unlocked ? Icons.location_on : Icons.lock_outline,
                size: 20,
                color: unlocked
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  zone.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ZoneRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.metalLight
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final points = [
      Offset(size.width * 0.21, 60),
      Offset(size.width * 0.21, 220),
      Offset(size.width * 0.50, 145),
      Offset(size.width * 0.79, 60),
      Offset(size.width * 0.79, 220),
    ];
    for (final (start, end) in [
      (points[0], points[2]),
      (points[1], points[2]),
      (points[2], points[3]),
      (points[2], points[4]),
    ]) {
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ZoneRoutePainter oldDelegate) => false;
}
