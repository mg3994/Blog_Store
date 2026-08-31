import 'package:blogstore/app/helpers/extensions.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../domain/entities/app_setting.dart';
import '../../bloc/app_setting_bloc.dart';
import '../../bloc/app_setting_event.dart';
import '../../bloc/app_setting_state.dart';

class AppSettingLocaleWidget extends StatelessWidget {
  const AppSettingLocaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AppSettingBloc, AppSettingState>(
      builder: (context, state) {
        final currentLocale = state.locale;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.languageSettingTitle,
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
              child: Column(
                children: AppLocale.supported.map((appLocale) {
                  final isSelected =
                      currentLocale.languageCode == appLocale.languageCode;

                  return RadioListTile<AppLocale>(
                    title: Text(appLocale.displayName),
                    subtitle: Text(appLocale.nativeName),
                    value: appLocale,
                    groupValue: AppLocale.fromLocale(currentLocale),
                    onChanged: (value) {
                      if (value != null) {
                        context.read<AppSettingBloc>().add(
                          AppSettingUpdateLocaleEvent(value.toLocale()),
                        );
                      }
                    },
                    selected: isSelected,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
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
