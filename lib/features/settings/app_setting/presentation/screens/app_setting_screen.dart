import 'package:blogstore/app/helpers/extensions.dart';
import 'package:kaisel/kaisel.dart';
import 'package:material_ui/material_ui.dart';

import 'widgets/app_setting_locale_widget.dart';
import 'widgets/app_setting_seed_color_widget.dart';
import 'widgets/app_setting_theme_mode_widget.dart';

class AppSettingScreen extends StatelessWidget {
  const AppSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOnlyPage = KaiselPageScope.maybeOf(context)?.isBottom ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.settingsAppearanceTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: !isOnlyPage && context.canPop(),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          const AppSettingThemeModeWidget(),
          const SizedBox(height: 24.0),
          const AppSettingSeedColorWidget(),
          const SizedBox(height: 24.0),
          const AppSettingLocaleWidget(),
        ],
      ),
    );
  }
}
