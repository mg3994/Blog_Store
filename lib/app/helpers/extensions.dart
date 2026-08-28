import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoLocalizations;
import 'package:drift/drift.dart' show Value;
import 'package:material_ui/material_ui.dart'
    show BuildContext, MaterialLocalizations, ThemeMode, Color;

import '../../config/app_config.dart' show AppConfig;
import '../../generated/app_localizations.dart' show AppLocalizations;
import '../../infrastructure/database/drift/app_database.dart'
    show AppDatabase, AppSetting, AppSettingsCompanion;

extension BuildContextLocalizationExtensions on BuildContext {
  /// The application's generated localization strings.
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Material localization strings.
  MaterialLocalizations get m10n => MaterialLocalizations.of(this);

  /// Cupertino localization strings.
  CupertinoLocalizations get c10n => CupertinoLocalizations.of(this);
}

extension AppDatabaseSettings on AppDatabase {
  /// Fetch stored settings directly as a Future without using Streams.
  Future<AppSetting> loadSettings() async {
    final setting = await (select(
      appSettings,
    )..where((t) => t.id.equals(1))).getSingleOrNull();

    return setting ??
        AppSetting(
          id: 1,
          themeMode: AppConfig.defaultThemeMode,
          languageCode: AppConfig.defaultLocale.languageCode,
          seedColor: AppConfig.defaultThemeSeedColorHex,
        );
  }

  /// Stream settings updates when reactive DB watching is needed.
  Stream<AppSetting> watchSettings() {
    return (select(
      appSettings,
    )..where((t) => t.id.equals(1))).watchSingleOrNull().map(
      (setting) =>
          setting ??
          AppSetting(
            id: 1,
            themeMode: AppConfig.defaultThemeMode,
            languageCode: AppConfig.defaultLocale.languageCode,
            seedColor: AppConfig.defaultThemeSeedColorHex,
          ),
    );
  }

  Future<void> updateSettings({
    ThemeMode? themeMode,
    String? languageCode,
    Color? seedColor,
  }) async {
    await into(appSettings).insertOnConflictUpdate(
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
