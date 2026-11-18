import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/navigation.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/pixel_header.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/pixel_segmented_control.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/state_views.dart';
import '../../player/widgets/robot_avatar.dart';
import '../models/threat_entry.dart';
import '../providers/threat_providers.dart';

class ThreatCodexScreen extends ConsumerStatefulWidget {
  const ThreatCodexScreen({super.key});

  @override
  ConsumerState<ThreatCodexScreen> createState() => _ThreatCodexScreenState();
}

class _ThreatCodexScreenState extends ConsumerState<ThreatCodexScreen> {
  int _selectedKind = 0;

  Future<void> _showThreat(ThreatEntry entry) => showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RobotAvatar(avatarId: entry.avatarId, pixel: 5),
            const SizedBox(height: 14),
            Text(
              entry.isIdentified ? entry.name : 'Registro cifrado',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading,
            ),
            const SizedBox(height: 8),
            Text(
              entry.isIdentified
                  ? entry.description
                  : 'Encuentra esta unidad para identificarla y completar '
                        'su registro.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            if (entry.isIdentified && entry.weakness != null) ...[
              const SizedBox(height: 12),
              Text('Debilidad: ${entry.weakness}', style: AppTextStyles.label),
            ],
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CERRAR'),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _content(List<ThreatEntry> entries) {
    final kind = _selectedKind == 0 ? ThreatKind.enemy : ThreatKind.boss;
    final filtered = entries.where((entry) => entry.kind == kind).toList();
    final identified = filtered.where((entry) => entry.isIdentified).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PixelSegmentedControl(
          labels: const ['Enemigos', 'Jefes'],
          selectedIndex: _selectedKind,
          onSelected: (index) => setState(() => _selectedKind = index),
        ),
        const SizedBox(height: 14),
        PixelPanel(
          title: _selectedKind == 0
              ? 'Amenazas registradas'
              : 'Jefes registrados',
          accent: true,
          child: Text(
            '$identified de ${filtered.length} identificados',
            style: AppTextStyles.body,
          ),
        ),
        const SizedBox(height: 14),
        if (filtered.isEmpty)
          const EmptyState(
            title: 'Sin registros',
            message: 'Aún no has identificado amenazas en esta partida.',
          )
        else
          for (final entry in filtered) ...[
            _ThreatCard(entry: entry, onTap: () => _showThreat(entry)),
            const SizedBox(height: 10),
          ],
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () => context.push(AppRoutes.codex),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Códex de personajes'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final threats = ref.watch(threatsProvider);
    return ScreenScaffold(
      centered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PixelHeader(
            title: 'Códex de amenazas',
            onBack: () => context.backOr(AppRoutes.codex),
          ),
          const SizedBox(height: 18),
          AsyncValueView<List<ThreatEntry>>(
            value: threats,
            loadingMessage: 'Descifrando amenazas...',
            onRetry: () => ref.invalidate(threatsProvider),
            data: _content,
          ),
        ],
      ),
    );
  }
}

class _ThreatCard extends StatelessWidget {
  const _ThreatCard({required this.entry, required this.onTap});

  final ThreatEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: entry.isIdentified ? entry.name : 'Amenaza no identificada',
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: PixelPanel(
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  border: Border.all(color: AppColors.metal, width: 2),
                ),
                child: entry.isIdentified
                    ? RobotAvatar(avatarId: entry.avatarId, pixel: 2.8)
                    : const Icon(
                        Icons.lock_outline,
                        color: AppColors.textSecondary,
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.isIdentified ? entry.name : '???',
                      style: AppTextStyles.heading,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.isIdentified
                          ? entry.description
                          : 'Registro sin identificar',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
