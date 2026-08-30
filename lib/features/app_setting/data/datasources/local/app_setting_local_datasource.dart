import 'package:drift/drift.dart';
import 'package:material_ui/material_ui.dart' show Color, ThemeMode;

import '../../../../../config/app_config.dart' show AppConfig;
import '../../../../../infrastructure/database/drift/app_database.dart'
    show AppDatabase, AppSettingsCompanion;
import '../../../domain/entities/app_setting.dart' show AppSetting;

abstract interface class AppSettingLocalDataSource {
  Future<AppSetting> loadSettings();
  Stream<AppSetting> watchSettings();
  Future<void> updateSettings({
    ThemeMode? themeMode,
    String? languageCode,
    Color? seedColor,
  });
}

final class AppSettingLocalDataSourceImpl implements AppSettingLocalDataSource {
  const AppSettingLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<AppSetting> loadSettings() async {
    final setting = await (_db.select(
      _db.appSettings,
    )..where((t) => t.id.equals(1))).getSingleOrNull();

    if (setting == null) {
      return AppSetting(
        id: 1,
        themeMode: AppConfig.defaultThemeMode,
        languageCode: AppConfig.defaultLocale.languageCode,
        seedColor: AppConfig.defaultThemeSeedColorHex,
      );
    }

    return AppSetting(
      id: setting.id,
      themeMode: setting.themeMode,
      languageCode: AppConfig.defaultLocale.languageCode,
      seedColor: setting.seedColor,
    );
  }

  @override
  Stream<AppSetting> watchSettings() {
    return (_db.select(
      _db.appSettings,
    )..where((t) => t.id.equals(1))).watchSingleOrNull().map((setting) {
      if (setting == null) {
        return AppSetting(
          id: 1,
          themeMode: AppConfig.defaultThemeMode,
          languageCode: AppConfig.defaultLocale.languageCode,
          seedColor: AppConfig.defaultThemeSeedColorHex,
        );
      }
      return AppSetting(
        id: setting.id,
        themeMode: setting.themeMode,
        languageCode: setting.languageCode,
        seedColor: setting.seedColor,
      );
    });
  }

  @override
  Future<void> updateSettings({
    ThemeMode? themeMode,
    String? languageCode,
    Color? seedColor,
  }) async {
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion(
            id: const Value(1),
            themeMode: themeMode != null
                ? Value(themeMode)
                : const Value.absent(),
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
