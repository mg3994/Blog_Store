import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/app/helpers/extensions.dart';
import 'package:blogstore/features/settings/app_setting/presentation/bloc/app_setting_bloc.dart';
import 'package:blogstore/injection/dependency_injection.dart';
import 'package:kaisel/kaisel.dart';
import 'package:material_ui/material_ui.dart';

import 'widgets/app_setting_locale_widget.dart' show AppSettingLocaleWidget;
import 'widgets/app_setting_seed_color_widget.dart'
    show AppSettingSeedColorWidget;
import 'widgets/app_setting_theme_mode_widget.dart'
    show AppSettingThemeModeWidget;

class AppSettingScreen extends StatelessWidget {
  const AppSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = context.canPop();

    return BlocSignalProvider<AppSettingBloc>.value(
      value: context.dependencies.appSettingBloc,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surfaceContainerLowest,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (canPop) ...[
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.pop(),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        context.l10n.settingsAppearanceTitle,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const AppSettingThemeModeWidget(),
                  const SizedBox(height: 32),
                  const AppSettingSeedColorWidget(),
                  const SizedBox(height: 32),
                  const AppSettingLocaleWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
