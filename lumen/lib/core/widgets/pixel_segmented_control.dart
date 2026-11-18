import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class PixelSegmentedControl extends StatelessWidget {
  const PixelSegmentedControl({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          if (index > 0) const SizedBox(width: 8),
          Expanded(
            child: Semantics(
              button: true,
              selected: index == selectedIndex,
              label: labels[index],
              onTap: () => onSelected(index),
              excludeSemantics: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSelected(index),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 44),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: index == selectedIndex
                        ? AppColors.primaryDark
                        : AppColors.surface,
                    border: Border.all(
                      color: index == selectedIndex
                          ? AppColors.primaryLight
                          : AppColors.metal,
                      width: 3,
                    ),
                  ),
                  child: Text(
                    labels[index].toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: index == selectedIndex
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
