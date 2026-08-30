part of 'app_setting_bloc.dart';

class AppSettingState {
  final ThemeMode themeMode;
  final Locale locale;
  final Color seedColor;

  const AppSettingState({
    required this.themeMode,
    required this.locale,
    required this.seedColor,
  });

  AppSettingState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    Color? seedColor,
  }) {
    return AppSettingState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      seedColor: seedColor ?? this.seedColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettingState &&
        other.themeMode == themeMode &&
        other.locale == locale &&
        other.seedColor == seedColor;
  }

  @override
  int get hashCode => Object.hash(themeMode, locale, seedColor);
}
