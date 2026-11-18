import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../player/widgets/robot_avatar.dart';

/// Hoja inferior para elegir avatar. Devuelve el id elegido o `null` si se
/// cierra sin elegir.
Future<String?> showAvatarPicker(
  BuildContext context, {
  required String current,
}) {
  return showModalBottomSheet<String>(
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
            const Text('Elige tu avatar', style: AppTextStyles.heading),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final avatar in RobotAvatars.all)
                  _AvatarOption(
                    avatar: avatar,
                    selected: avatar.id == current,
                    onTap: () => Navigator.of(sheetContext).pop(avatar.id),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _AvatarOption extends StatelessWidget {
  const _AvatarOption({
    required this.avatar,
    required this.selected,
    required this.onTap,
  });

  final RobotAvatarData avatar;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: avatar.name,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: 88,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            border: Border.all(
              color: selected ? AppColors.primaryLight : AppColors.metal,
              width: 3,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RobotAvatar(avatarId: avatar.id, pixel: 4),
              const SizedBox(height: 8),
              Text(avatar.name, style: AppTextStyles.caption),
            ],
          ),
        ),
      ),
    );
  }
}
