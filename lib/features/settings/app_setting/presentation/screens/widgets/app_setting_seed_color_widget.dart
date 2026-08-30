import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/features/settings/app_setting/presentation/bloc/app_setting_bloc.dart';
import 'package:material_ui/material_ui.dart';

class AppSettingSeedColorWidget extends StatelessWidget {
  const AppSettingSeedColorWidget({super.key});

  static const List<Color> seedColors = [
    Color(0xFF4F378A), // Design primary purple
    Color(0xFF3B82F6), // Blue
    Color(0xFF10B981), // Emerald/Green
    Color(0xFFF59E0B), // Amber/Yellow
    Color(0xFFEF4444), // Red
    Color(0xFFEC4899), // Pink
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSignalSelector<AppSettingBloc, AppSettingState, Color>(
      selector: (state) => state.seedColor,
      builder: (context, activeColor) {
        final appSettingBloc = context.read<AppSettingBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accent Color',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: seedColors.map((color) {
                  final isSelected = activeColor.toARGB32() == color.toARGB32();
                  return GestureDetector(
                    onTap: () {
                      appSettingBloc.add(
                        AppSettingUpdateSeedColorEvent(color),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (isSelected)
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: color,
                                width: 2,
                              ),
                            ),
                          ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white, size: 22)
                              : null,
                        ),
                      ],
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
