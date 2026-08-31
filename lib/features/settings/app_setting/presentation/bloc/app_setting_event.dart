part of 'app_setting_bloc.dart';

sealed class AppSettingEvent {
  const AppSettingEvent();
}

final class GetAppSettingEvent extends AppSettingEvent {
  const GetAppSettingEvent();
}

final class AppSettingUpdateThemeModeEvent extends AppSettingEvent {
  const AppSettingUpdateThemeModeEvent(this.themeMode);
  final ThemeMode themeMode;
}

final class AppSettingTemporarilyChangeThemeModeEvent extends AppSettingEvent {
  const AppSettingTemporarilyChangeThemeModeEvent(this.themeMode);
  final ThemeMode themeMode;
}

final class AppSettingUpdateLocaleEvent extends AppSettingEvent {
  const AppSettingUpdateLocaleEvent(this.locale);
  final Locale locale;
}

final class AppSettingTemporarilyChangeLocaleEvent extends AppSettingEvent {
  const AppSettingTemporarilyChangeLocaleEvent(this.locale);
  final Locale locale;
}

final class AppSettingUpdateSeedColorEvent extends AppSettingEvent {
  const AppSettingUpdateSeedColorEvent(this.seedColor);
  final Color seedColor;
}

final class AppSettingTemporarilyChangeSeedColorEvent extends AppSettingEvent {
  const AppSettingTemporarilyChangeSeedColorEvent(this.seedColor);
  final Color seedColor;
}
