import 'dart:async';

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart'
    show BlocSignalBuilder, MultiBlocSignalProvider, BlocSignalProvider;
import 'package:blogstore/app/helpers/extensions.dart';
import 'package:blogstore/app/router/router.dart' show AppRouter;
import 'package:flutter/foundation.dart' show PlatformDispatcher;
import 'package:intl/intl.dart' show Intl;
import 'package:kaisel/kaisel.dart';
import 'package:material_ui/material_ui.dart'
    show
        Widget,
        MaterialApp,
        BuildContext,
        StatefulWidget,
        State,
        VoidCallback,
        SizedBox,
        FlutterError;

import '../core/theme/app_theme.dart';
import '../features/app_setting/presentation/bloc/app_setting_bloc.dart'
    show AppSettingBloc, AppSettingState, GetAppSettingEvent;
import '../generated/app_localizations.dart';
import '../infrastructure/firebase/notifications/background_messaging.dart'
    show firebaseMessagingBackgroundHandler;
import '../injection/dependency_injection.dart'
    show Dependencies, DependenciesProvider;

class BootStrap extends StatefulWidget {
  const BootStrap({super.key, required this.onReady, this.appSettingsBloc});

  final VoidCallback onReady;
  final AppSettingBloc? appSettingsBloc;

  @override
  State<BootStrap> createState() => _BootStrapState();
}

class _BootStrapState extends State<BootStrap> {
  KaiselRouterConfig? _routerConfig;
  Dependencies? _dependencies;
  AppSettingBloc? _appSettingsBloc;

  Future<void> _initAsync() async {
    final dependencies = Dependencies.create();

    try {
      // 1. Initialize Firebase Core
      await dependencies.firebaseInitializer.initialize();

      // 2. Register FCM Background Handler immediately post-Firebase initialization
      await dependencies.notificationGateway.registerBackgroundHandler(
        firebaseMessagingBackgroundHandler,
      );

      FlutterError.onError = dependencies.crashReporter.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        dependencies.crashReporter.recordError(error, stack, fatal: true);
        return true;
      };

      final routerConfig = AppRouter(dependencies).createConfig();
      Intl.defaultLocale = PlatformDispatcher.instance.locale
          .toLanguageTag(); //usefull For Manish //! TODO: support
      final settingsBloc =
          widget.appSettingsBloc ?? dependencies.appSettingBloc;

      // Preloads saved SQLite theme/locale into memory BEFORE native splash screen vanishes
      await settingsBloc.loadSettings();

      if (!mounted) return;

      setState(() {
        _dependencies = dependencies;
        _appSettingsBloc = settingsBloc;
        _routerConfig = routerConfig;
      });
    } catch (error, stack) {
      dependencies.crashReporter.recordError(error, stack, fatal: true);
    } finally {
      widget.onReady();
    }

    await dependencies.notificationGateway.requestPermission();
  }

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  @override
  void dispose() {
    if (widget.appSettingsBloc == null) {
      unawaited(_appSettingsBloc?.close());
    }
    _dependencies?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dependencies = _dependencies;
    final settingsBloc = _appSettingsBloc;
    final routerConfig = _routerConfig;

    if (dependencies == null || settingsBloc == null || routerConfig == null) {
      return const SizedBox.shrink();
    }

    return DependenciesProvider(
      dependencies: dependencies,
      child: MultiBlocSignalProvider(
        providers: [
          BlocSignalProvider<AppSettingBloc>.value(value: settingsBloc),
        ],
        child: BlocSignalBuilder<AppSettingBloc, AppSettingState>(
          bloc: settingsBloc,
          builder: (context, state) {
            return MaterialApp.router(
              routerConfig: routerConfig,
              onGenerateTitle: (context) => context.l10n.appName,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              themeMode: state.themeMode,
              locale: state.locale,
              theme: AppTheme.light(seed: state.seedColor),
              darkTheme: AppTheme.dark(seed: state.seedColor),
            );
          },
        ),
      ),
    );
  }
}
