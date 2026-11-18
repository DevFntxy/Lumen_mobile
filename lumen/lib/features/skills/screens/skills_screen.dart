import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/navigation.dart';
import '../../../app/router/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/async_form_mixin.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/pixel_button.dart';
import '../../../core/widgets/pixel_header.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/pixel_tile.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/status_console.dart';
import '../models/skill_tree.dart';
import '../providers/skills_providers.dart';

class SkillsScreen extends ConsumerStatefulWidget {
  const SkillsScreen({super.key});

  @override
  ConsumerState<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends ConsumerState<SkillsScreen>
    with AsyncFormMixin<SkillsScreen> {
  static const _branchNames = {
    SkillBranch.combat: 'Combate',
    SkillBranch.exploration: 'Exploración',
    SkillBranch.support: 'Soporte',
  };

  Future<void> _openSkill(SkillTree tree, SkillDefinition skill) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: PixelPanel(
            title: skill.name,
            accent: tree.isAvailable(skill),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(skill.description, style: AppTextStyles.body),
                const SizedBox(height: 10),
                Text(
                  'Nivel ${tree.levelOf(skill.id)} / ${skill.maxLevel}',
                  style: AppTextStyles.label,
                ),
                if (!tree.isAvailable(skill)) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Requiere: ${skill.prerequisites.join(', ')}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                PixelButton(
                  label: tree.levelOf(skill.id) >= skill.maxLevel
                      ? 'Nivel máximo'
                      : 'Mejorar · ${tree.nextCost(skill.id)} puntos',
                  onPressed: !tree.isAvailable(skill) ||
                          tree.levelOf(skill.id) >= skill.maxLevel ||
                          tree.points < tree.nextCost(skill.id) ||
                          busy
                      ? null
                      : () async {
                          Navigator.pop(context);
                          await runGuarded(
                            () => ref
                                .read(skillsControllerProvider.notifier)
                                .upgrade(skill.id),
                            progress: 'Mejorando habilidad...',
                          );
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _respec() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Reasignar puntos', style: AppTextStyles.heading),
        content: Text(
          'Se reiniciarán las habilidades y recuperarás todos los puntos '
          'invertidos.',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('REASIGNAR'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await runGuarded(
      () => ref.read(skillsControllerProvider.notifier).respec(),
      progress: 'Reasignando puntos...',
    );
  }

  Widget _tree(SkillTree tree) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PixelPanel(
          title: 'Puntos disponibles',
          accent: true,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${tree.points}',
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
              Text(
                '${tree.pointsSpent} invertidos',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final branch in SkillBranch.values) ...[
          PixelPanel(
            title: _branchNames[branch]!,
            child: Column(
              children: [
                for (final skill
                    in tree.skills.where((item) => item.branch == branch)) ...[
                  PixelTile(
                    title: skill.name,
                    subtitle: tree.levelOf(skill.id) > 0
                        ? 'Nivel ${tree.levelOf(skill.id)} / ${skill.maxLevel}'
                        : tree.isAvailable(skill)
                            ? 'Disponible · ${tree.nextCost(skill.id)} puntos'
                            : 'Bloqueada · requiere ${skill.prerequisites.join(', ')}',
                    leading: Icon(
                      tree.levelOf(skill.id) > 0
                          ? Icons.check_circle
                          : tree.isAvailable(skill)
                              ? Icons.radio_button_unchecked
                              : Icons.lock_outline,
                      color: tree.levelOf(skill.id) > 0
                          ? AppColors.primaryLight
                          : AppColors.textSecondary,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                    onTap: () => _openSkill(tree, skill),
                    bottom: LinearProgressIndicator(
                      value: tree.levelOf(skill.id) / skill.maxLevel,
                      minHeight: 6,
                      backgroundColor: AppColors.metal,
                      color: AppColors.primaryLight,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
        PixelButton(
          label: 'Reasignar puntos',
          variant: PixelButtonVariant.secondary,
          onPressed: busy || tree.pointsSpent == 0 ? null : _respec,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tree = ref.watch(skillsControllerProvider);
    return ScreenScaffold(
      centered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PixelHeader(
            title: 'Habilidades',
            onBack: () => context.backOr(AppRoutes.inventory),
          ),
          const SizedBox(height: 20),
          AsyncValueView<SkillTree>(
            value: tree,
            loadingMessage: 'Cargando habilidades...',
            onRetry: () => ref.invalidate(skillsControllerProvider),
            data: _tree,
          ),
          if (status.isNotEmpty) ...[
            const SizedBox(height: 16),
            StatusConsole(message: status, isError: statusIsError),
          ],
        ],
      ),
    );
  }
}
