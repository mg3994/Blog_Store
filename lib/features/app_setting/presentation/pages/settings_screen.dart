import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:material_ui/material_ui.dart';

import '../bloc/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const List<Color> seedColors = [
    Colors.indigo,
    Colors.blue,
    Colors.teal,
    Colors.green,
    Colors.amber,
    Colors.orange,
    Colors.red,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
      ),
      body: BlocSignalBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final settingsBloc = context.read<SettingsBloc>();

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
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
                        style: theme.textTheme.titleMedium?.copyWith(
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
                        selected: {state.themeMode},
                        onSelectionChanged: (selected) {
                          if (selected.isNotEmpty) {
                            settingsBloc.add(
                              SettingsUpdateThemeModeEvent(selected.first),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
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
                        'Accent Color',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: seedColors.map((color) {
                          final isSelected = state.seedColor.toARGB32() == color.toARGB32();
                          return GestureDetector(
                            onTap: () {
                              settingsBloc.add(
                                SettingsUpdateSeedColorEvent(color),
                              );
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: theme.colorScheme.onSurface,
                                        width: 3,
                                      )
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withOpacity(0.4),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    'Language',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    state.locale.languageCode == 'en' ? 'English' : state.locale.languageCode,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    final newLocale = state.locale.languageCode == 'en'
                        ? const Locale('es')
                        : const Locale('en');
                    settingsBloc.add(SettingsUpdateLocaleEvent(newLocale));
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
