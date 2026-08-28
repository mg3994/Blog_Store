import 'package:blogstore/features/app_setting/domain/entities/app_setting.dart';
import 'package:blogstore/features/app_setting/domain/repositories/app_setting_repository.dart';
import 'package:blogstore/features/app_setting/domain/usecases/get_app_settings.dart';
import 'package:blogstore/features/app_setting/domain/usecases/update_locale.dart';
import 'package:blogstore/features/app_setting/domain/usecases/update_seed_color.dart';
import 'package:blogstore/features/app_setting/domain/usecases/update_theme_mode.dart';
import 'package:blogstore/features/app_setting/domain/usecases/watch_app_settings.dart';
import 'package:blogstore/features/app_setting/presentation/bloc/settings_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

final class FakeAppSettingRepository implements AppSettingRepository {
  AppSetting _setting = const AppSetting(
    themeMode: ThemeMode.system,
    locale: Locale('en'),
    seedColor: Colors.indigo,
  );

  @override
  Future<AppSetting> getSettings() async => _setting;

  @override
  Stream<AppSetting> watchSettings() async* {
    yield _setting;
  }

  @override
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    _setting = _setting.copyWith(themeMode: themeMode);
  }

  @override
  Future<void> updateLocale(Locale locale) async {
    _setting = _setting.copyWith(locale: locale);
  }

  @override
  Future<void> updateSeedColor(Color seedColor) async {
    _setting = _setting.copyWith(seedColor: seedColor);
  }
}

void main() {
  group('AppSetting Domain & Use Cases', () {
    late FakeAppSettingRepository repository;
    late GetAppSettings getAppSettings;
    late WatchAppSettings watchAppSettings;
    late UpdateThemeMode updateThemeMode;
    late UpdateLocale updateLocale;
    late UpdateSeedColor updateSeedColor;

    setUp(() {
      repository = FakeAppSettingRepository();
      getAppSettings = GetAppSettings(repository);
      watchAppSettings = WatchAppSettings(repository);
      updateThemeMode = UpdateThemeMode(repository);
      updateLocale = UpdateLocale(repository);
      updateSeedColor = UpdateSeedColor(repository);
    });

    test('getSettings returns current AppSetting', () async {
      final setting = await getAppSettings();
      expect(setting.themeMode, ThemeMode.system);
      expect(setting.locale, const Locale('en'));
      expect(setting.seedColor, Colors.indigo);
    });

    test('updateThemeMode updates repository state', () async {
      await updateThemeMode(ThemeMode.dark);
      final setting = await getAppSettings();
      expect(setting.themeMode, ThemeMode.dark);
    });

    test('updateLocale updates repository state', () async {
      await updateLocale(const Locale('es'));
      final setting = await getAppSettings();
      expect(setting.locale, const Locale('es'));
    });

    test('updateSeedColor updates repository state', () async {
      await updateSeedColor(Colors.red);
      final setting = await getAppSettings();
      expect(setting.seedColor, Colors.red);
    });

    test('watchAppSettings emits setting stream', () async {
      expect(
        watchAppSettings(),
        emits(
          const AppSetting(
            themeMode: ThemeMode.system,
            locale: Locale('en'),
            seedColor: Colors.indigo,
          ),
        ),
      );
    });
  });

  group('SettingsBloc Presentation', () {
    late FakeAppSettingRepository repository;
    late GetAppSettings getAppSettings;
    late UpdateThemeMode updateThemeMode;
    late UpdateLocale updateLocale;
    late UpdateSeedColor updateSeedColor;
    late SettingsBloc bloc;

    setUp(() {
      repository = FakeAppSettingRepository();
      getAppSettings = GetAppSettings(repository);
      updateThemeMode = UpdateThemeMode(repository);
      updateLocale = UpdateLocale(repository);
      updateSeedColor = UpdateSeedColor(repository);

      bloc = SettingsBloc(
        getAppSettings: getAppSettings,
        updateThemeMode: updateThemeMode,
        updateLocale: updateLocale,
        updateSeedColor: updateSeedColor,
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state matches defaults', () {
      expect(bloc.stateValue.themeMode, ThemeMode.system);
      expect(bloc.stateValue.locale, const Locale('en'));
    });

    test('loadSettings loads saved settings into state', () async {
      await repository.updateThemeMode(ThemeMode.dark);
      await bloc.loadSettings();

      expect(bloc.stateValue.themeMode, ThemeMode.dark);
    });

    test('SettingsUpdateThemeModeEvent updates state and calls usecase', () async {
      bloc.add(const SettingsUpdateThemeModeEvent(ThemeMode.light));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.stateValue.themeMode, ThemeMode.light);
      final saved = await repository.getSettings();
      expect(saved.themeMode, ThemeMode.light);
    });

    test('SettingsUpdateLocaleEvent updates state and calls usecase', () async {
      bloc.add(const SettingsUpdateLocaleEvent(Locale('es')));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.stateValue.locale, const Locale('es'));
      final saved = await repository.getSettings();
      expect(saved.locale, const Locale('es'));
    });

    test('SettingsUpdateSeedColorEvent updates state and calls usecase', () async {
      bloc.add(const SettingsUpdateSeedColorEvent(Colors.green));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.stateValue.seedColor, Colors.green);
      final saved = await repository.getSettings();
      expect(saved.seedColor, Colors.green);
    });
  });
}
