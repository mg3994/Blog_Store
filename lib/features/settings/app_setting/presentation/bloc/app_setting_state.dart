part of 'app_setting_bloc.dart';

class AppSettingState {
  final ThemeMode themeMode;
  final Locale locale;
  final Color seedColor;
  final bool hasCompletedOnboarding;
  final bool hasGivenConsent;
  final bool analyticsStorageConsentGranted;
  final bool adStorageConsentGranted;
  final bool adUserDataConsentGranted;
  final bool adPersonalizationSignalsConsentGranted;

  const AppSettingState({
    required this.themeMode,
    required this.locale,
    required this.seedColor,
    this.hasCompletedOnboarding = false,
    this.hasGivenConsent = false,
    this.analyticsStorageConsentGranted = false,
    this.adStorageConsentGranted = false,
    this.adUserDataConsentGranted = false,
    this.adPersonalizationSignalsConsentGranted = false,
  });

  AppSettingState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    Color? seedColor,
    bool? hasCompletedOnboarding,
    bool? hasGivenConsent,
    bool? analyticsStorageConsentGranted,
    bool? adStorageConsentGranted,
    bool? adUserDataConsentGranted,
    bool? adPersonalizationSignalsConsentGranted,
  }) {
    return AppSettingState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      seedColor: seedColor ?? this.seedColor,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      hasGivenConsent: hasGivenConsent ?? this.hasGivenConsent,
      analyticsStorageConsentGranted:
          analyticsStorageConsentGranted ?? this.analyticsStorageConsentGranted,
      adStorageConsentGranted:
          adStorageConsentGranted ?? this.adStorageConsentGranted,
      adUserDataConsentGranted:
          adUserDataConsentGranted ?? this.adUserDataConsentGranted,
      adPersonalizationSignalsConsentGranted:
          adPersonalizationSignalsConsentGranted ??
              this.adPersonalizationSignalsConsentGranted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettingState &&
        other.themeMode == themeMode &&
        other.locale == locale &&
        other.seedColor == seedColor &&
        other.hasCompletedOnboarding == hasCompletedOnboarding &&
        other.hasGivenConsent == hasGivenConsent &&
        other.analyticsStorageConsentGranted ==
            analyticsStorageConsentGranted &&
        other.adStorageConsentGranted == adStorageConsentGranted &&
        other.adUserDataConsentGranted == adUserDataConsentGranted &&
        other.adPersonalizationSignalsConsentGranted ==
            adPersonalizationSignalsConsentGranted;
  }

  @override
  int get hashCode => Object.hash(
        themeMode,
        locale,
        seedColor,
        hasCompletedOnboarding,
        hasGivenConsent,
        analyticsStorageConsentGranted,
        adStorageConsentGranted,
        adUserDataConsentGranted,
        adPersonalizationSignalsConsentGranted,
      );
}
