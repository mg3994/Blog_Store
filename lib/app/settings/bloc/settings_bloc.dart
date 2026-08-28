// import 'dart:async';

// import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
// import 'package:material_ui/material_ui.dart' show Locale, ThemeMode;

// import '../../../config/app_config.dart' show AppConfig;
// import '../../../infrastructure/database/drift/app_database.dart'
//     show AppDatabase;
// import '../../helpers/extensions.dart' show AppDatabaseSettings;

// part 'settings_event.dart';
// part 'settings_state.dart';

// class SettingsBloc extends BlocSignal<SettingsEvent, SettingsState> {
//   SettingsBloc(this._db)
//     : super(
//         initialState: const SettingsState(
//           themeMode: AppConfig.defaultThemeMode,
//           locale: AppConfig.defaultLocale,
//         ),
//       );
//   final AppDatabase _db; // avoid AppDatabase try passsing Dependencies as we will allso record analytics record on events

//   @override
//   FutureOr<void> onEvent(SettingsEvent event) async {
//     super.onEvent(event);

//     emit(switch (event) {
//       SettingsUpadeThemeModeEvent(:final themeMode) =>
//         stateValue, //copy with and  await _db.updateSettings(themeMode: mode);
//       SettingsUpdateLocaleEvent(:final locale) => stateValue,
//     });

//     await _db.updateSettings(
//       languageCode: stateValue.locale.languageCode,
//       themeMode: stateValue.themeMode,
//     );
//   }
// }

///////////////////
///
///
///
import 'dart:async';

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:material_ui/material_ui.dart' show Locale, ThemeMode;

import '../../../config/app_config.dart' show AppConfig;
import '../../../injection/dependency_injection.dart' show Dependencies;
import '../../helpers/extensions.dart' show AppDatabaseSettings;

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends BlocSignal<SettingsEvent, SettingsState> {
  SettingsBloc(this._dependencies)
    : super(
        initialState: const SettingsState(
          themeMode: AppConfig.defaultThemeMode,
          locale: AppConfig.defaultLocale,
        ),
      ) {
    // unawaited(loadSettings());
  }

  final Dependencies _dependencies;

  /// Loads saved user settings from the database into state.
  /// Call and await this during startup to prevent initial UI theme flash.
  Future<void> loadSettings() async {
    final db = _dependencies.database;
    try {
      final setting = await (db.select(
        db.appSettings,
      )..where((t) => t.id.equals(1))).getSingleOrNull();

      if (setting != null) {
        emit(
          SettingsState(
            themeMode: setting.themeMode,
            locale: Locale(setting.languageCode),
          ),
        );
      }
    } catch (error, stack) {
      _dependencies.crashReporter.recordError(error, stack);
    }
  }

  @override
  FutureOr<void> onEvent(SettingsEvent event) async {
    super.onEvent(event);

    final db = _dependencies.database;
    final analytics = _dependencies.analyticsGateway;

    switch (event) {
      case SettingsUpdateThemeModeEvent(:final themeMode):
        emit(stateValue.copyWith(themeMode: themeMode));
        await db.updateSettings(themeMode: themeMode);
        await analytics.logEvent(
          'theme_changed',
          parameters: {'theme_mode': themeMode.name},
        );

      case SettingsUpdateLocaleEvent(:final locale):
        emit(stateValue.copyWith(locale: locale));
        await db.updateSettings(languageCode: locale.languageCode);
        await analytics.logEvent(
          'locale_changed',
          parameters: {'language_code': locale.languageCode},
        );
    }
  }
}
