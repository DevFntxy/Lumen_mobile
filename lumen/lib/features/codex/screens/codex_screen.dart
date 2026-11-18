import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/pixel_button.dart';
import '../../../core/widgets/pixel_icons.dart';
import '../../../core/widgets/pixel_nav_card.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/pixel_progress_bar.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/state_views.dart';
import '../../player/widgets/robot_avatar.dart';
import '../models/codex_entry.dart';
import '../providers/codex_providers.dart';

class CodexScreen extends ConsumerWidget {
  const CodexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(codexCharactersProvider);

    return ScreenScaffold(
      centered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CodexHeader(),
          const SizedBox(height: 16),
          AsyncValueView<List<CodexEntry>>(
            value: entries,
            loadingMessage: 'Descifrando archivos...',
            onRetry: () => ref.invalidate(codexCharactersProvider),
            data: (list) => list.isEmpty
                ? const EmptyState(
                    title: 'Códex sin registros',
                    message:
                        'Los personajes encontrados durante la partida '
                        'aparecerán aquí al sincronizar tu cuenta.',
                  )
                : _CodexContent(entries: list),
          ),
        ],
      ),
    );
  }
}

class _CodexHeader extends StatelessWidget {
  const _CodexHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text('Códex de personajes', style: AppTextStyles.title),
        ),
        const PixelIcon(rows: PixelIcons.codex, color: AppColors.primaryLight),
      ],
    );
  }
}

class _CodexContent extends StatelessWidget {
  const _CodexContent({required this.entries});

  final List<CodexEntry> entries;

  @override
  Widget build(BuildContext context) {
    final unlocked = entries.where((entry) => entry.isUnlocked).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PixelPanel(
          title: 'Archivos identificados',
          accent: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '$unlocked de ${entries.length} registros',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 10),
              PixelProgressBar(
                value: entries.isEmpty ? 0 : unlocked / entries.length,
                segments: 12,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 8.0;
            final itemWidth = (constraints.maxWidth - spacing * 2) / 3;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final entry in entries)
                  _CodexTile(
                    entry: entry,
                    width: itemWidth,
                    onTap: () => _showEntry(context, entry),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        PixelNavCard(
          title: 'Códex de amenazas',
          subtitle: 'Consulta enemigos y jefes registrados',
          onTap: () => context.push(AppRoutes.bestiary),
        ),
        const SizedBox(height: 12),
        PixelNavCard(
          title: 'Fragmentos de memoria',
          subtitle: 'Revisa archivos narrativos recuperados',
          onTap: () => context.push(AppRoutes.memories),
        ),
        const SizedBox(height: 12),
        PixelNavCard(
          title: 'Logros',
          subtitle: 'Consulta tus insignias y hazañas',
          onTap: () => context.push(AppRoutes.achievements),
        ),
      ],
    );
  }

  Future<void> _showEntry(BuildContext context, CodexEntry entry) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: AppColors.metal, width: 3),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: _CodexPortrait(entry: entry, pixel: 5)),
              const SizedBox(height: 14),
              Text(
                entry.isUnlocked ? entry.name : 'Registro cifrado',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: 8),
              Text(
                entry.isUnlocked
                    ? entry.description
                    : 'Este archivo sigue bloqueado. Descubre la unidad en una '
                          'partida sincronizada para descifrarlo.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 18),
              PixelButton(
                label: 'Cerrar',
                variant: PixelButtonVariant.secondary,
                onPressed: () => Navigator.of(sheetContext).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CodexTile extends StatelessWidget {
  const _CodexTile({
    required this.entry,
    required this.width,
    required this.onTap,
  });

  final CodexEntry entry;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: entry.isUnlocked ? entry.name : 'Registro cifrado',
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: width,
          child: PixelPanel(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Column(
              children: [
                _CodexPortrait(entry: entry),
                const SizedBox(height: 8),
                Text(
                  entry.isUnlocked ? entry.name : '???',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: entry.isUnlocked
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CodexPortrait extends StatelessWidget {
  const _CodexPortrait({required this.entry, this.pixel = 2.5});

  final CodexEntry entry;
  final double pixel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border.all(
          color: entry.isUnlocked ? AppColors.metal : AppColors.textSecondary,
          width: 2,
        ),
      ),
      child: entry.isUnlocked && entry.avatarId != null
          ? RobotAvatar(avatarId: entry.avatarId!, pixel: pixel)
          : Icon(
              entry.isUnlocked ? Icons.memory : Icons.lock_outline,
              color: entry.isUnlocked
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              size: 22,
            ),
    );
  }
}
