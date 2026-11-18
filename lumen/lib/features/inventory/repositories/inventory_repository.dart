import '../models/inventory_item.dart';

abstract interface class InventoryRepository {
  Future<List<InventoryItem>> fetchItems({required String userId});
}
