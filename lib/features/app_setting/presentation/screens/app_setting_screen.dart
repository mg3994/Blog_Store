import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/features/app_setting/presentation/bloc/app_setting_bloc.dart';
import 'package:blogstore/injection/dependency_injection.dart';
import 'package:flutter/widgets.dart';

import 'widgets/app_setting_locale_widget.dart' show AppSettingLocaleWidget;
import 'widgets/app_setting_seed_color_widget.dart'
    show AppSettingSeedColorWidget;
import 'widgets/app_setting_theme_mode_widget.dart'
    show AppSettingThemeModeWidget;

class AppSettingScreen extends StatelessWidget {
  const AppSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSignalProvider(
      create: (context) => AppSettingBloc(
        getAppSettings: context.dependencies.getAppSettings,
        updateThemeMode: context.dependencies.updateThemeMode,
        updateLocale: context.dependencies.updateLocale,
        updateSeedColor: context.dependencies.updateSeedColor,
      )..add(GetAppSettingEvent()),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const AppSettingThemeModeWidget(),
          const SizedBox(height: 16),
          const AppSettingSeedColorWidget(),
          const SizedBox(height: 16),
          const AppSettingLocaleWidget(),
        ],
      ),
    );
  }
}
