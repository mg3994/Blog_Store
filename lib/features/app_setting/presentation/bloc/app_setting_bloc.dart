import 'dart:async';

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:material_ui/material_ui.dart'
    show Color, Colors, Locale, ThemeMode;

import '../../../../config/app_config.dart' show AppConfig;
import '../../../../core/monitoring/crash_reporter.dart' show CrashReporter;
import '../../domain/usecases/get_app_settings.dart';
import '../../domain/usecases/update_locale.dart';
import '../../domain/usecases/update_seed_color.dart';
import '../../domain/usecases/update_theme_mode.dart';

part 'app_setting_event.dart';
part 'app_setting_state.dart';

class AppSettingBloc extends BlocSignal<AppSettingEvent, AppSettingState> {
  AppSettingBloc({
    required GetAppSettings getAppSettings,
    required UpdateThemeMode updateThemeMode,
    required UpdateLocale updateLocale,
    required UpdateSeedColor updateSeedColor,
    CrashReporter? crashReporter,
  }) : _getAppSettings = getAppSettings,
       _updateThemeMode = updateThemeMode,
       _updateLocale = updateLocale,
       _updateSeedColor = updateSeedColor,
       _crashReporter = crashReporter,
       super(
         initialState: const AppSettingState(
           themeMode: AppConfig.defaultThemeMode,
           locale: AppConfig.defaultLocale,
           seedColor: Colors.indigo,
         ),
       );

  final GetAppSettings _getAppSettings;
  final UpdateThemeMode _updateThemeMode;
  final UpdateLocale _updateLocale;
  final UpdateSeedColor _updateSeedColor;
  final CrashReporter? _crashReporter;

  /// Loads saved user settings into state.
  /// Awaited in bootstrap initialization to prevent UI theme flickering.
  Future<void> loadSettings() async {
    try {
      final setting = await _getAppSettings();
      emit(
        AppSettingState(
          themeMode: setting.themeMode,
          locale: Locale.fromSubtags(languageCode: setting.languageCode),
          seedColor: Color(setting.seedColor),
        ),
      );
    } catch (error, stack) {
      _crashReporter?.recordError(error, stack);
    }
  }

  @override
  FutureOr<void> onEvent(AppSettingEvent event) async {
    super.onEvent(event);

    switch (event) {
      case AppSettingUpdateThemeModeEvent(themeMode: final themeMode):
        if (stateValue.themeMode == themeMode) return;
        emit(stateValue.copyWith(themeMode: themeMode));
        await _updateThemeMode(themeMode);

      case AppSettingUpdateLocaleEvent(locale: final locale):
        if (stateValue.locale == locale) return;
        emit(stateValue.copyWith(locale: locale));
        await _updateLocale(locale);

      case AppSettingUpdateSeedColorEvent(seedColor: final seedColor):
        if (stateValue.seedColor == seedColor) return;
        emit(stateValue.copyWith(seedColor: seedColor));
        await _updateSeedColor(seedColor);
      case GetAppSettingEvent():
        loadSettings();
    }
  }
}
