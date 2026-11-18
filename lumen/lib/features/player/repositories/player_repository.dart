import '../models/player_profile.dart';
import '../models/player_progress.dart';

/// Contrato de datos del jugador. Hoy lo implementa [MockPlayerRepository];
/// con el backend se agrega una implementación HTTP y se cambia el provider.
abstract interface class PlayerRepository {
  /// `null` si la cuenta aún no tiene partida sincronizada.
  Future<PlayerProgress?> fetchProgress({required String userId});

  Future<PlayerProfile> fetchProfile({required String userId});

  Future<PlayerProfile> updateAvatar({
    required String userId,
    required String avatarId,
  });
}
