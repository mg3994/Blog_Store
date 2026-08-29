import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/features/app_setting/presentation/bloc/app_setting_bloc.dart';
import 'package:material_ui/material_ui.dart'
    show
        Colors,
        StatelessWidget,
        Color,
        Widget,
        BuildContext,
        Card,
        EdgeInsets,
        SizedBox,
        Offset,
        Icon,
        BorderRadius,
        RoundedRectangleBorder,
        CrossAxisAlignment,
        FontWeight,
        Text,
        BoxShape,
        Border,
        BoxShadow,
        BoxDecoration,
        Icons,
        Container,
        GestureDetector,
        Wrap,
        Column,
        Padding;

import '../../../../../app/helpers/extensions.dart'
    show BuildContextLocalizationExtensions;

class AppSettingSeedColorWidget extends StatelessWidget {
  const AppSettingSeedColorWidget({super.key});

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
    return BlocSignalSelector<AppSettingBloc, AppSettingState, Color>(
      selector: (state) => state.seedColor,
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
                  'Accent Color',
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: seedColors.map((color) {
                    final isSelected = value.toARGB32() == color.toARGB32();
                    return GestureDetector(
                      onTap: () {
                        appSettingBloc.add(
                          AppSettingUpdateSeedColorEvent(color),
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
                                  color: context.theme.colorScheme.onSurface,
                                  width: 3,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: color.withAlpha(25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
