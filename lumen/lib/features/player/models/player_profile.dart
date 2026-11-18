import '../../auth/models/sso_provider.dart';

/// Cuenta externa vinculada. Si [accountLabel] es `null`, no está vinculada.
class LinkedProvider {
  const LinkedProvider({required this.provider, this.accountLabel});

  final SsoProvider provider;
  final String? accountLabel;

  bool get isLinked => accountLabel != null;
}

class PlayerProfile {
  const PlayerProfile({
    required this.avatarId,
    required this.accountCreated,
    required this.linkedProviders,
  });

  /// Perfil por defecto cuando aún no hay sesión.
  factory PlayerProfile.guest() => PlayerProfile(
        avatarId: 'm4',
        accountCreated: DateTime.now(),
        linkedProviders: const [],
      );

  final String avatarId;
  final DateTime accountCreated;
  final List<LinkedProvider> linkedProviders;

  PlayerProfile copyWith({String? avatarId}) => PlayerProfile(
        avatarId: avatarId ?? this.avatarId,
        accountCreated: accountCreated,
        linkedProviders: linkedProviders,
      );
}
