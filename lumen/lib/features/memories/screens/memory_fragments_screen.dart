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
import '../../../core/widgets/pixel_progress_bar.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/state_views.dart';
import '../models/memory_fragment.dart';
import '../providers/memory_providers.dart';

class MemoryFragmentsScreen extends ConsumerStatefulWidget {
  const MemoryFragmentsScreen({super.key});

  @override
  ConsumerState<MemoryFragmentsScreen> createState() =>
      _MemoryFragmentsScreenState();
}

class _MemoryFragmentsScreenState extends ConsumerState<MemoryFragmentsScreen> {
  int _selectedSector = 0;

  static const _sectorNames = ['Todos', 'Fundición', 'Inundado', 'Núcleo'];

  Future<void> _showFragment(MemoryFragment fragment) =>
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
                Text(
                  fragment.isUnlocked ? fragment.title : 'Fragmento cifrado',
                  style: AppTextStyles.heading,
                ),
                const SizedBox(height: 8),
                if (fragment.isUnlocked)
                  Text(fragment.summary, style: AppTextStyles.caption),
                const SizedBox(height: 14),
                Text(
                  fragment.isUnlocked
                      ? '“${fragment.transcript}”'
                      : 'Este registro está cifrado. Explora el sector para '
                            'encontrar el fragmento original.',
                  style: AppTextStyles.body,
                ),
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

  Widget _content(List<MemoryFragment> fragments) {
    final visible = _selectedSector == 0
        ? fragments
        : fragments.where((fragment) {
            return fragment.sector.index == _selectedSector - 1;
          }).toList();
    final unlocked = fragments.where((fragment) => fragment.isUnlocked).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PixelPanel(
          title: 'Fragmentos descifrados',
          accent: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '$unlocked / ${fragments.length}',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 8),
              PixelProgressBar(
                value: fragments.isEmpty ? 0 : unlocked / fragments.length,
                segments: 12,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PixelSegmentedControl(
          labels: _sectorNames,
          selectedIndex: _selectedSector,
          onSelected: (index) => setState(() => _selectedSector = index),
        ),
        const SizedBox(height: 14),
        if (visible.isEmpty)
          const EmptyState(
            title: 'Sin fragmentos',
            message: 'No hay registros en esta sección.',
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 8.0;
              final width = (constraints.maxWidth - spacing * 2) / 3;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final fragment in visible)
                    _FragmentTile(
                      fragment: fragment,
                      width: width,
                      onTap: () => _showFragment(fragment),
                    ),
                ],
              );
            },
          ),
        const SizedBox(height: 14),
        TextButton(
          onPressed: () => context.push(AppRoutes.codex),
          child: const Text('VOLVER AL CÓDEX'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final fragments = ref.watch(memoryFragmentsProvider);
    return ScreenScaffold(
      centered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PixelHeader(
            title: 'Fragmentos de memoria',
            onBack: () => context.backOr(AppRoutes.codex),
          ),
          const SizedBox(height: 18),
          AsyncValueView<List<MemoryFragment>>(
            value: fragments,
            loadingMessage: 'Descifrando memoria...',
            onRetry: () => ref.invalidate(memoryFragmentsProvider),
            data: _content,
          ),
        ],
      ),
    );
  }
}

class _FragmentTile extends StatelessWidget {
  const _FragmentTile({
    required this.fragment,
    required this.width,
    required this.onTap,
  });

  final MemoryFragment fragment;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: fragment.isUnlocked ? fragment.title : 'Fragmento cifrado',
      onTap: onTap,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: width,
          child: PixelPanel(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            accent: fragment.isUnlocked,
            child: Column(
              children: [
                Icon(
                  fragment.isUnlocked ? Icons.memory : Icons.lock_outline,
                  size: 28,
                  color: fragment.isUnlocked
                      ? AppColors.primaryLight
                      : AppColors.textSecondary,
                ),
                const SizedBox(height: 8),
                Text(
                  fragment.isUnlocked ? fragment.title : '???',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
