import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_providers.dart';
import '../models/player_profile.dart';
import '../models/player_progress.dart';
import '../repositories/mock_player_repository.dart';
import '../repositories/player_repository.dart';

/// Punto único donde se elige la implementación del repositorio.
final playerRepositoryProvider = Provider<PlayerRepository>(
  (ref) => MockPlayerRepository(),
);

/// Progreso del jugador con sesión; `null` si aún no tiene partida.
final playerProgressProvider = FutureProvider<PlayerProgress?>((ref) async {
  final userId = ref.watch(authControllerProvider.select((s) => s.user?.id));
  if (userId == null) return null;
  return ref.watch(playerRepositoryProvider).fetchProgress(userId: userId);
});

final playerProfileProvider =
    AsyncNotifierProvider<PlayerProfileController, PlayerProfile>(
  PlayerProfileController.new,
);

class PlayerProfileController extends AsyncNotifier<PlayerProfile> {
  @override
  Future<PlayerProfile> build() async {
    final userId = ref.watch(authControllerProvider.select((s) => s.user?.id));
    if (userId == null) return PlayerProfile.guest();
    return ref.watch(playerRepositoryProvider).fetchProfile(userId: userId);
  }

  /// Cambia el avatar. Relanza el error para que la pantalla lo muestre.
  Future<void> selectAvatar(String avatarId) async {
    final userId = ref.read(authControllerProvider).user?.id;
    if (userId == null) return;
    final updated = await ref
        .read(playerRepositoryProvider)
        .updateAvatar(userId: userId, avatarId: avatarId);
    state = AsyncData(updated);
  }
}
