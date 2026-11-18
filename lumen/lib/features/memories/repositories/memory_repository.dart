import '../models/memory_fragment.dart';

abstract interface class MemoryRepository {
  Future<List<MemoryFragment>> fetchFragments({required String userId});
}
