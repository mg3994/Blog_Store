import 'package:material_ui/material_ui.dart' show Color, Locale, ThemeMode;

import '../entities/app_setting.dart';

abstract interface class AppSettingRepository {
  Future<AppSetting> getSettings();
  Stream<AppSetting> watchSettings();
  Future<void> updateThemeMode(ThemeMode themeMode);
  Future<void> updateLocale(Locale locale);
  Future<void> updateSeedColor(Color seedColor);
}
