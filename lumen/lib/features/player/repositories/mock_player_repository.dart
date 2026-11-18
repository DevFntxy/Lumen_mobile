import '../../../app/config/app_config.dart';
import '../../../core/mock/mock_data.dart';
import '../../auth/models/sso_provider.dart';
import '../models/player_profile.dart';
import '../models/player_progress.dart';
import 'player_repository.dart';

/// Datos simulados: solo la cuenta demo tiene partida; las demás cuentas
/// arrancan sin progreso (para probar el estado vacío).
class MockPlayerRepository implements PlayerRepository {
  MockPlayerRepository({Duration? latency})
      : _latency = latency ?? AppConfig.mockLatency;

  final Duration _latency;
  final Map<String, PlayerProfile> _profiles = {};

  Future<void> _wait() => Future<void>.delayed(_latency);

  @override
  Future<PlayerProgress?> fetchProgress({required String userId}) async {
    await _wait();
    if (userId != MockData.demoUserId) return null;
    return PlayerProgress(
      actName: MockData.demoActName,
      actProgress: MockData.demoActProgress,
      overallCompletion: MockData.demoOverallCompletion,
      lastSession: MockData.demoLastSession,
      zonesUnlocked: MockData.demoZonesUnlocked,
      zonesTotal: MockData.demoZonesTotal,
      activeQuests: MockData.demoActiveQuests,
      codexUnlocked: MockData.demoCodexUnlocked,
      codexTotal: MockData.demoCodexTotal,
      achievementsUnlocked: MockData.demoAchievementsUnlocked,
      achievementsTotal: MockData.demoAchievementsTotal,
    );
  }

  @override
  Future<PlayerProfile> fetchProfile({required String userId}) async {
    await _wait();
    return _profiles.putIfAbsent(userId, () => _newProfile(userId));
  }

  @override
  Future<PlayerProfile> updateAvatar({
    required String userId,
    required String avatarId,
  }) async {
    await _wait();
    final current = _profiles.putIfAbsent(userId, () => _newProfile(userId));
    final updated = current.copyWith(avatarId: avatarId);
    _profiles[userId] = updated;
    return updated;
  }

  PlayerProfile _newProfile(String userId) {
    final isDemo = userId == MockData.demoUserId;
    return PlayerProfile(
      avatarId: MockData.demoAvatarId,
      accountCreated: isDemo ? MockData.demoAccountCreated : DateTime.now(),
      linkedProviders: [
        LinkedProvider(
          provider: SsoProvider.google,
          accountLabel: isDemo ? MockData.demoGoogleAccount : null,
        ),
        const LinkedProvider(provider: SsoProvider.apple),
        LinkedProvider(
          provider: SsoProvider.github,
          accountLabel: isDemo ? MockData.demoGithubAccount : null,
        ),
      ],
    );
  }
}
