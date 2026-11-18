import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../models/inventory_item.dart';
import '../repositories/inventory_repository.dart';
import '../repositories/mock_inventory_repository.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>(
  (ref) => MockInventoryRepository(),
);

final inventoryProvider = FutureProvider<List<InventoryItem>>((ref) async {
  final userId = ref.watch(authControllerProvider.select((s) => s.user?.id));
  if (userId == null) return const [];
  return ref.watch(inventoryRepositoryProvider).fetchItems(userId: userId);
});
