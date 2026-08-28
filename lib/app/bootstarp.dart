import 'dart:async';

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart'
    show BlocSignalBuilder, MultiBlocSignalProvider, BlocSignalProvider;
import 'package:blogstore/app/helpers/extensions.dart';
import 'package:blogstore/app/router/router.dart' show AppRouter;
import 'package:flutter/foundation.dart' show PlatformDispatcher;
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
import '../features/app_setting/presentation/bloc/settings_bloc.dart'
    show SettingsBloc, SettingsState;
import '../generated/app_localizations.dart';
import '../infrastructure/firebase/notifications/background_messaging.dart'
    show firebaseMessagingBackgroundHandler;
import '../injection/dependency_injection.dart'
    show Dependencies, DependenciesProvider;

class BootStrap extends StatefulWidget {
  const BootStrap({super.key, required this.onReady, this.settingsBloc});

  final VoidCallback onReady;
  final SettingsBloc? settingsBloc;

  @override
  State<BootStrap> createState() => _BootStrapState();
}

class _BootStrapState extends State<BootStrap> {
  KaiselRouterConfig? _routerConfig;
  Dependencies? _dependencies;
  SettingsBloc? _settingsBloc;

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
      final settingsBloc = widget.settingsBloc ??
          SettingsBloc(
            getAppSettings: dependencies.getAppSettings,
            updateThemeMode: dependencies.updateThemeMode,
            updateLocale: dependencies.updateLocale,
            updateSeedColor: dependencies.updateSeedColor,
            crashReporter: dependencies.crashReporter,
          );

      // Preloads saved SQLite theme/locale into memory BEFORE native splash screen vanishes
      await settingsBloc.loadSettings();

      if (!mounted) return;

      setState(() {
        _dependencies = dependencies;
        _settingsBloc = settingsBloc;
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
    if (widget.settingsBloc == null) {
      unawaited(_settingsBloc?.close());
    }
    _dependencies?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dependencies = _dependencies;
    final settingsBloc = _settingsBloc;
    final routerConfig = _routerConfig;

    if (dependencies == null || settingsBloc == null || routerConfig == null) {
      return const SizedBox.shrink();
    }

    return DependenciesProvider(
      dependencies: dependencies,
      child: MultiBlocSignalProvider(
        providers: [
          BlocSignalProvider<SettingsBloc>.value(value: settingsBloc),
        ],
        child: BlocSignalBuilder<SettingsBloc, SettingsState>(
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
