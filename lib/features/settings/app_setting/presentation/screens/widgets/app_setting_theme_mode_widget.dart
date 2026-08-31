import 'package:blogstore/app/helpers/extensions.dart';
import 'package:material_ui/material_ui.dart';

import '../../bloc/app_setting_bloc.dart';
import '../../bloc/app_setting_event.dart';
import '../../bloc/app_setting_state.dart';

class AppSettingThemeModeWidget extends StatelessWidget {
  const AppSettingThemeModeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AppSettingBloc, AppSettingState>(
      builder: (context, state) {
        final currentThemeMode = state.themeMode;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.themeModeTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.system,
                    label: Text(context.l10n.themeModeSystem),
                    icon: const Icon(Icons.settings_brightness),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.light,
                    label: Text(context.l10n.themeModeLight),
                    icon: const Icon(Icons.light_mode),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark,
                    label: Text(context.l10n.themeModeDark),
                    icon: const Icon(Icons.dark_mode),
                  ),
                ],
                selected: {currentThemeMode},
                onSelectionChanged: (newSelection) {
                  if (newSelection.isNotEmpty) {
                    context.read<AppSettingBloc>().add(
                      AppSettingUpdateThemeModeEvent(newSelection.first),
                    );
                  }
                },
                style: SegmentedButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
