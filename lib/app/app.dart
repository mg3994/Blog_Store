import 'package:bloc_signals_flutter/bloc_signals_flutter.dart'
    show BlocSignalBuilder;
import 'package:blogstore/app/helpers/extensions.dart';
import 'package:blogstore/app/router/router.dart' show createRouterConfig;

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

import '../generated/app_localizations.dart';

import '../injection/dependency_injection.dart'
    show Dependencies, DependenciesProvider;
import 'settings/cubit/settings.dart' show SettingsCubit, SettingsState;

class BootStrap extends StatefulWidget {
  const new({super.key, required this.onReady});
  final VoidCallback onReady;

  @override
  State<BootStrap> createState() => _BootStrapState();
}

class _BootStrapState extends State<BootStrap> {
  KaiselRouterConfig? _routerConfig;
  Dependencies? _dependencies;

  SettingsCubit? _settingsCubit; // use provider of Bloc Signal

  Future<void> _initAsync() async {
    final dependencies = Dependencies.create();

    try {
      await dependencies.firebaseInitializer.initialize();

      FlutterError.onError = dependencies.crashReporter.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        dependencies.crashReporter.recordError(error, stack, fatal: true);
        return true;
      };

      final routerConfig = createRouterConfig(dependencies);
      final settingsCubit = SettingsCubit(dependencies.database);
      await settingsCubit.loadSettings();

      if (!mounted) return;

      setState(() {
        _dependencies = dependencies;
        _settingsCubit = settingsCubit;
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
    _settingsCubit?.close();
    _dependencies?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dependencies = _dependencies;
    final settingsCubit = _settingsCubit;
    final routerConfig = _routerConfig;

    if (dependencies == null || settingsCubit == null || routerConfig == null) {
      return const SizedBox.shrink();
    }
    return DependenciesProvider(
      dependencies: dependencies,
      child: BlocSignalBuilder<SettingsCubit, SettingsState>(
        bloc: _settingsCubit,
        builder: (context, state) {
          return MaterialApp.router(
            routerConfig: _routerConfig,
            onGenerateTitle: (context) => context.l10n.appName,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            themeMode: state.themeMode,
            locale: state.locale,

            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
          );
        },
      ),
    );
  }
}
