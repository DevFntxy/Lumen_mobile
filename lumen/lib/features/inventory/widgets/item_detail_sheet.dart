import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/pixel_button.dart';
import '../models/inventory_item.dart';
import 'item_icons.dart';

Future<void> showItemDetailSheet(BuildContext context, InventoryItem item) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      side: BorderSide(color: AppColors.metal, width: 3),
    ),
    builder: (sheetContext) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ItemIcon(type: item.type, pixel: 5),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: AppTextStyles.heading),
                      Text(item.type.label, style: AppTextStyles.label),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(item.description, style: AppTextStyles.body),
            const SizedBox(height: 16),
            if (item.capacity != null)
              _ItemStatLine(
                label: 'Cantidad',
                value: '${item.quantity} de ${item.capacity}',
              ),
            for (final stat in item.stats)
              _ItemStatLine(label: stat.label, value: stat.value),
            const SizedBox(height: 20),
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

class _ItemStatLine extends StatelessWidget {
  const _ItemStatLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label.toUpperCase(), style: AppTextStyles.label),
          ),
          Text(value, style: AppTextStyles.body),
        ],
      ),
    );
  }
}
