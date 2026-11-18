import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/pixel_button.dart';
import '../../../core/widgets/pixel_header.dart';
import '../../../core/widgets/pixel_panel.dart';
import '../../../core/widgets/pixel_progress_bar.dart';
import '../../../core/widgets/screen_scaffold.dart';
import '../../../core/widgets/state_views.dart';
import '../models/inventory_item.dart';
import '../providers/inventory_providers.dart';
import '../widgets/item_detail_sheet.dart';
import '../widgets/item_icons.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(inventoryProvider);

    return ScreenScaffold(
      centered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PixelHeader(title: 'Inventario'),
          const SizedBox(height: 16),
          PixelButton(
            label: 'Árbol de habilidades',
            variant: PixelButtonVariant.secondary,
            compact: true,
            onPressed: () => context.push(AppRoutes.skills),
          ),
          const SizedBox(height: 16),
          AsyncValueView<List<InventoryItem>>(
            value: items,
            loadingMessage: 'Cargando inventario...',
            onRetry: () => ref.invalidate(inventoryProvider),
            data: (list) => list.isEmpty
                ? const EmptyState(
                    title: 'Inventario vacío',
                    message:
                        'Los objetos que recolecte M-4 en el juego '
                        'aparecerán aquí cuando sincronices tu cuenta.',
                  )
                : _InventoryList(items: list),
          ),
        ],
      ),
    );
  }
}

class _InventoryList extends StatelessWidget {
  const _InventoryList({required this.items});

  final List<InventoryItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          items.length == 1 ? '1 objeto' : '${items.length} objetos',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: 8),
        for (final item in items) ...[
          Semantics(
            button: true,
            label: '${item.name}. ${item.summary}',
            onTap: () => showItemDetailSheet(context, item),
            excludeSemantics: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => showItemDetailSheet(context, item),
              child: PixelPanel(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ItemIcon(type: item.type),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: AppTextStyles.heading.copyWith(fontSize: 17),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.summary.isEmpty
                                ? item.type.label
                                : item.summary,
                            style: AppTextStyles.caption,
                          ),
                          if (item.fill case final fill?) ...[
                            const SizedBox(height: 8),
                            PixelProgressBar(value: fill, segments: 10),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
