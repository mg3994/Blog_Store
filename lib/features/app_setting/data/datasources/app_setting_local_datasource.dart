import 'package:drift/drift.dart';
import 'package:material_ui/material_ui.dart' show Color, Locale, ThemeMode;

import '../../../../config/app_config.dart';
import '../../../../infrastructure/database/drift/app_database.dart';
import '../../domain/entities/app_setting.dart';

abstract interface class AppSettingLocalDataSource {
  Future<AppSetting> loadSettings();
  Stream<AppSetting> watchSettings();
  Future<void> updateSettings({
    ThemeMode? themeMode,
    String? languageCode,
    Color? seedColor,
  });
}

final class AppSettingLocalDataSourceImpl
    implements AppSettingLocalDataSource {
  const AppSettingLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<AppSetting> loadSettings() async {
    final setting = await (_db.select(
      _db.appSettings,
    )..where((t) => t.id.equals(1))).getSingleOrNull();

    if (setting == null) {
      return const AppSetting(
        themeMode: AppConfig.defaultThemeMode,
        locale: AppConfig.defaultLocale,
        seedColor: Color(AppConfig.defaultThemeSeedColorHex),
      );
    }

    return AppSetting(
      themeMode: setting.themeMode,
      locale: Locale(setting.languageCode),
      seedColor: Color(setting.seedColor),
    );
  }

  @override
  Stream<AppSetting> watchSettings() {
    return (_db.select(
      _db.appSettings,
    )..where((t) => t.id.equals(1))).watchSingleOrNull().map(
      (setting) {
        if (setting == null) {
          return const AppSetting(
            themeMode: AppConfig.defaultThemeMode,
            locale: AppConfig.defaultLocale,
            seedColor: Color(AppConfig.defaultThemeSeedColorHex),
          );
        }
        return AppSetting(
          themeMode: setting.themeMode,
          locale: Locale(setting.languageCode),
          seedColor: Color(setting.seedColor),
        );
      },
    );
  }

  @override
  Future<void> updateSettings({
    ThemeMode? themeMode,
    String? languageCode,
    Color? seedColor,
  }) async {
    await _db.into(_db.appSettings).insertOnConflictUpdate(
      AppSettingsCompanion(
        id: const Value(1),
        themeMode: themeMode != null ? Value(themeMode) : const Value.absent(),
        languageCode: languageCode != null
            ? Value(languageCode)
            : const Value.absent(),
        seedColor: seedColor != null
            ? Value(seedColor.toARGB32())
            : const Value.absent(),
      ),
    );
  }
}
