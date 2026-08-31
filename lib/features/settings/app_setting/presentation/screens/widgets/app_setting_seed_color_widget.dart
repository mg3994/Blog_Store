import 'package:blogstore/app/helpers/extensions.dart';
import 'package:material_ui/material_ui.dart';

import '../../bloc/app_setting_bloc.dart';
import '../../bloc/app_setting_event.dart';
import '../../bloc/app_setting_state.dart';

class AppSettingSeedColorWidget extends StatelessWidget {
  const AppSettingSeedColorWidget({super.key});

  static const List<Color> seedColors = [
    Colors.deepPurple,
    Colors.blue,
    Colors.teal,
    Colors.green,
    Colors.amber,
    Colors.deepOrange,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AppSettingBloc, AppSettingState>(
      builder: (context, state) {
        final currentSeedColor = state.seedColor;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.themeColorTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                children: seedColors.map((color) {
                  final isSelected = currentSeedColor.value == color.value;

                  return InkWell(
                    onTap: () {
                      context.read<AppSettingBloc>().add(
                        AppSettingUpdateSeedColorEvent(color),
                      );
                    },
                    borderRadius: BorderRadius.circular(24.0),
                    child: Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: theme.colorScheme.onSurface,
                                width: 3.0,
                              )
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 24.0,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
