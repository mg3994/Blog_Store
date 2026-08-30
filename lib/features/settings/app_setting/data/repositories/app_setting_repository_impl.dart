import 'package:material_ui/material_ui.dart' show Color, Locale, ThemeMode;

import '../../../../../core/analytics/analytics_gateway.dart';
import '../../domain/entities/app_setting.dart' show AppSetting;
import '../../domain/repositories/app_setting_repository.dart'
    show AppSettingRepository;
import '../datasources/local/app_setting_local_datasource.dart'
    show AppSettingLocalDataSource;

final class AppSettingRepositoryImpl implements AppSettingRepository {
  const AppSettingRepositoryImpl({
    required this._localDataSource,
    this._analyticsGateway,
  });

  final AppSettingLocalDataSource _localDataSource;
  final AnalyticsGateway? _analyticsGateway;

  @override
  Future<AppSetting> getSettings() => _localDataSource.loadSettings();

  @override
  Stream<AppSetting> watchSettings() => _localDataSource.watchSettings();

  @override
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    await _localDataSource.updateSettings(themeMode: themeMode);
    await _analyticsGateway?.logEvent(
      'theme_changed',
      parameters: {'theme_mode': themeMode.name},
    );
  }

  @override
  Future<void> updateLocale(Locale locale) async {
    await _localDataSource.updateSettings(languageCode: locale.languageCode);
    await _analyticsGateway?.logEvent(
      'locale_changed',
      parameters: {'language_code': locale.languageCode},
    );
  }

  @override
  Future<void> updateSeedColor(Color seedColor) async {
    await _localDataSource.updateSettings(seedColor: seedColor);
    await _analyticsGateway?.logEvent(
      'seed_color_changed',
      parameters: {'seed_color': seedColor.toARGB32().toRadixString(16)},
    );
  }
}
