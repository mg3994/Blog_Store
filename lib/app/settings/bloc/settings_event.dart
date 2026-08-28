part of 'settings_bloc.dart';

sealed class SettingsEvent {
  const SettingsEvent();
}

final class SettingsUpdateThemeModeEvent extends SettingsEvent {
  const SettingsUpdateThemeModeEvent(this.themeMode);
  final ThemeMode themeMode;
}

final class SettingsUpdateLocaleEvent extends SettingsEvent {
  const SettingsUpdateLocaleEvent(this.locale);
  final Locale locale;
}
