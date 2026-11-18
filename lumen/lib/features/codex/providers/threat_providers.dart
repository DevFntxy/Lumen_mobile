import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../models/threat_entry.dart';
import '../repositories/mock_threat_repository.dart';
import '../repositories/threat_repository.dart';

final threatRepositoryProvider = Provider<ThreatRepository>(
  (ref) => MockThreatRepository(),
);

final threatsProvider = FutureProvider<List<ThreatEntry>>((ref) async {
  final userId = ref.watch(authControllerProvider.select((s) => s.user?.id));
  if (userId == null) return const [];
  return ref.watch(threatRepositoryProvider).fetchThreats(userId: userId);
});
