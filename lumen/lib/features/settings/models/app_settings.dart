import '../../../app/config/app_config.dart';

class AppSettings {
  const AppSettings({
    required this.languageCode,
    required this.notificationsEnabled,
    required this.crtEnabled,
    required this.soundVolume,
  });

  factory AppSettings.defaults() => AppSettings(
        languageCode: 'es',
        notificationsEnabled: true,
        crtEnabled: AppConfig.crtEffect,
        soundVolume: 0.7,
      );

  final String languageCode;
  final bool notificationsEnabled;
  final bool crtEnabled;
  final double soundVolume;

  AppSettings copyWith({
    String? languageCode,
    bool? notificationsEnabled,
    bool? crtEnabled,
    double? soundVolume,
  }) =>
      AppSettings(
        languageCode: languageCode ?? this.languageCode,
        notificationsEnabled:
            notificationsEnabled ?? this.notificationsEnabled,
        crtEnabled: crtEnabled ?? this.crtEnabled,
        soundVolume: soundVolume ?? this.soundVolume,
      );
}
