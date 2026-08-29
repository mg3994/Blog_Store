import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show Card, ListTile, Icons;

import '../../bloc/app_setting_bloc.dart'
    show AppSettingBloc, AppSettingState, AppSettingUpdateLocaleEvent;

class AppSettingLocaleWidget extends StatelessWidget {
  const AppSettingLocaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSignalSelector<AppSettingBloc, AppSettingState, Locale>(
      selector: (state) => state.locale,
      builder: (context, value) {
        final appSettingBloc = context.read<AppSettingBloc>();
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: AppLocalizations.supportedLocales.map((locale) {
              final isSelected = locale.languageCode == value.languageCode;
              // Synchronously look up the AppLocalizations instance for this specific locale
              final targetLocalizations = lookupAppLocalizations(locale);
              return ListTile(
                title: FutureBuilder<AppLocalizations>(
                  future: targetLocalizations,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!.localeName);
                    }
                    // Fallback display while the ARB file chunk loads
                    return Text(locale.languageCode.toUpperCase());
                  },
                ),
                trailing: isSelected ? const Icon(Icons.check, size: 16) : null,
                onTap: () {
                  appSettingBloc.add(AppSettingUpdateLocaleEvent(locale));
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
