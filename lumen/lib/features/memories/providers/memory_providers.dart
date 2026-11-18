import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../models/memory_fragment.dart';
import '../repositories/memory_repository.dart';
import '../repositories/mock_memory_repository.dart';

final memoryRepositoryProvider = Provider<MemoryRepository>(
  (ref) => MockMemoryRepository(),
);

final memoryFragmentsProvider = FutureProvider<List<MemoryFragment>>((ref) async {
  final userId = ref.watch(authControllerProvider.select((s) => s.user?.id));
  if (userId == null) return const [];
  return ref
      .watch(memoryRepositoryProvider)
      .fetchFragments(userId: userId);
});
