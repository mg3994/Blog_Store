import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/features/app_setting/presentation/bloc/app_setting_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../app/helpers/extensions.dart'
    show BuildContextLocalizationExtensions;

class AppSettingThemeModeWidget extends StatelessWidget {
  const AppSettingThemeModeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSignalSelector<AppSettingBloc, AppSettingState, ThemeMode>(
      selector: (state) => state.themeMode,
      builder: (context, value) {
        final appSettingBloc = context.read<AppSettingBloc>();

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme Mode',
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      label: Text('System'),
                      icon: Icon(Icons.brightness_auto),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode),
                    ),
                  ],
                  selected: {value},
                  onSelectionChanged: (selected) {
                    if (selected.isNotEmpty) {
                      appSettingBloc.add(
                        AppSettingUpdateThemeModeEvent(selected.first),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
