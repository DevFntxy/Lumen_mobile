import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../models/codex_entry.dart';
import '../repositories/codex_repository.dart';
import '../repositories/mock_codex_repository.dart';

final codexRepositoryProvider = Provider<CodexRepository>(
  (ref) => MockCodexRepository(),
);

final codexCharactersProvider = FutureProvider<List<CodexEntry>>((ref) async {
  final userId = ref.watch(authControllerProvider.select((s) => s.user?.id));
  if (userId == null) return const [];
  return ref.watch(codexRepositoryProvider).fetchCharacters(userId: userId);
});
