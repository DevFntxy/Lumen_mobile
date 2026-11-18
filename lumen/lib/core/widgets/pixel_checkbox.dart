import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

/// Casilla de verificación integrada con `Form` (usa `validator`).
class PixelCheckbox extends FormField<bool> {
  PixelCheckbox({
    super.key,
    required Widget label,
    super.validator,
    bool enabled = true,
    bool initialValue = false,
    ValueChanged<bool>? onChanged,
  }) : super(
          enabled: enabled,
          initialValue: initialValue,
          builder: (field) {
            final checked = field.value ?? false;
            final hasError = field.hasError;

            void toggle() {
              final next = !checked;
              field.didChange(next);
              onChanged?.call(next);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Semantics(
                      checked: checked,
                      enabled: enabled,
                      onTap: enabled ? toggle : null,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: enabled ? toggle : null,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceRaised,
                              border: Border.all(
                                color: hasError
                                    ? AppColors.errorText
                                    : (checked ? AppColors.primaryLight : AppColors.metal),
                                width: 3,
                              ),
                            ),
                            child: checked
                                ? const Center(
                                    child: SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: ColoredBox(color: AppColors.primaryLight),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: label),
                  ],
                ),
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      field.errorText ?? '',
                      style: AppTextStyles.caption.copyWith(color: AppColors.errorText),
                    ),
                  ),
              ],
            );
          },
        );
}
