import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoLocalizations;
import 'package:drift/drift.dart' show Value;
import 'package:material_ui/material_ui.dart'
    show BuildContext, MaterialLocalizations, ThemeMode;

import '../../config/app_config.dart' show AppConfig;
import '../../generated/app_localizations.dart' show AppLocalizations;
import '../../infrastructure/database/drift/app_database.dart'
    show AppDatabase, UserSetting, UserSettingsCompanion;

extension BuildContextLocalizationExtensions on BuildContext {
  /// The application's generated localization strings.
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Material localization strings.
  MaterialLocalizations get m10n => MaterialLocalizations.of(this);

  /// Cupertino localization strings.
  CupertinoLocalizations get c10n => CupertinoLocalizations.of(this);
}

extension AppDatabaseSettings on AppDatabase {
  Stream<UserSetting> watchSettings() {
    return (select(
      userSettings,
    )..where((t) => t.id.equals(1))).watchSingleOrNull().map(
      (setting) =>
          setting ??
          UserSetting(
            id: 1,
            themeMode: AppConfig.defaultThemeMode,
            languageCode: AppConfig.defaultLocale.languageCode,
          ),
    );
  }

  Future<void> updateSettings({
    ThemeMode? themeMode,
    String? languageCode,
  }) async {
    await into(userSettings).insertOnConflictUpdate(
      UserSettingsCompanion(
        id: const Value(1),
        themeMode: themeMode != null ? Value(themeMode) : const Value.absent(),
        languageCode: languageCode != null
            ? Value(languageCode)
            : const Value.absent(),
      ),
    );
  }
}
