import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart'
    show FirebaseMessaging;

import 'package:material_ui/material_ui.dart'
    show BuildContext, InheritedWidget;

import '../core/analytics/analytics_gateway.dart' show AnalyticsGateway;
import '../core/auth/access_token_provider.dart';
import '../core/location/location_service.dart' show LocationService;
import '../core/monitoring/crash_reporter.dart' show CrashReporter;
import '../core/notifications/notification_gateway.dart'
    show NotificationGateway;

import '../features/app_setting/data/datasources/local/app_setting_local_datasource.dart'
    show AppSettingLocalDataSourceImpl, AppSettingLocalDataSource;
import '../features/app_setting/data/repositories/app_setting_repository_impl.dart';
import '../features/app_setting/domain/repositories/app_setting_repository.dart';
import '../features/app_setting/domain/usecases/get_app_settings.dart';
import '../features/app_setting/domain/usecases/update_locale.dart';
import '../features/app_setting/domain/usecases/update_seed_color.dart';
import '../features/app_setting/domain/usecases/update_theme_mode.dart';
import '../features/app_setting/domain/usecases/watch_app_settings.dart';

import '../infrastructure/auth/firebase_access_token_provider.dart';
import '../infrastructure/database/drift/app_database.dart';

import '../infrastructure/firebase/firebase_analytics_gateway.dart'
    show FirebaseAnalyticsGateway;
import '../infrastructure/firebase/firebase_crash_reporter.dart'
    show FirebaseCrashReporter;
import '../infrastructure/firebase/firebase_initializer.dart'
    show FirebaseInitializer, DefaultFirebaseInitializer;
import '../infrastructure/firebase/firebase_notification_gateway.dart'
    show FirebaseNotificationGateway;
import '../infrastructure/location/geolocator_location_service.dart'
    show GeolocatorLocationService;

final class Dependencies {
  factory Dependencies.create() {
    final db = AppDatabase();
    return Dependencies._(
      database: db,
      firebaseInitializer: DefaultFirebaseInitializer(),
      appSettingLocalDataSource: AppSettingLocalDataSourceImpl(db),
    );
  }

  // Non-const constructor allows late final fields
  Dependencies._({
    required this.database,
    required this.firebaseInitializer,
    required this.appSettingLocalDataSource,
  });

  final AppDatabase database;
  final FirebaseInitializer firebaseInitializer;
  final AppSettingLocalDataSource appSettingLocalDataSource;

  // Lazily initialized on first access (after await firebaseInitializer.initialize())
  late final AccessTokenProvider accessTokenProvider =
      FirebaseAccessTokenProvider(FirebaseAuth.instance);

  late final NotificationGateway notificationGateway =
      FirebaseNotificationGateway(FirebaseMessaging.instance);

  late final CrashReporter crashReporter = FirebaseCrashReporter(
    FirebaseCrashlytics.instance,
  );

  late final AnalyticsGateway analyticsGateway = FirebaseAnalyticsGateway(
    FirebaseAnalytics.instance,
  );

  late final LocationService locationService = GeolocatorLocationService();

  late final AppSettingRepository appSettingRepository =
      AppSettingRepositoryImpl(
        localDataSource: appSettingLocalDataSource,
        analyticsGateway: analyticsGateway,
      );

  late final GetAppSettings getAppSettings = GetAppSettings(
    appSettingRepository,
  );
  late final WatchAppSettings watchAppSettings = WatchAppSettings(
    appSettingRepository,
  );
  late final UpdateThemeMode updateThemeMode = UpdateThemeMode(
    appSettingRepository,
  );
  late final UpdateLocale updateLocale = UpdateLocale(appSettingRepository);
  late final UpdateSeedColor updateSeedColor = UpdateSeedColor(
    appSettingRepository,
  );

  Future<void> dispose() => database.close();
}

class DependenciesProvider extends InheritedWidget {
  const DependenciesProvider({
    super.key,
    required this.dependencies,
    required super.child,
  });

  final Dependencies dependencies;

  static Dependencies of(BuildContext context) {
    final DependenciesProvider? result = context
        .dependOnInheritedWidgetOfExactType<DependenciesProvider>();
    assert(result != null, 'No DependenciesProvider found in context');
    return result!.dependencies;
  }

  @override
  bool updateShouldNotify(DependenciesProvider oldWidget) =>
      dependencies != oldWidget.dependencies;
}

extension DependenciesBuildContextX on BuildContext {
  Dependencies get dependencies => DependenciesProvider.of(this);
}
