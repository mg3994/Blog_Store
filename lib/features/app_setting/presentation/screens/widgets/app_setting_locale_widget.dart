// import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
// import 'package:blogstore/generated/app_localizations.dart';
// import 'package:flutter/widgets.dart';
// import 'package:material_ui/material_ui.dart'
//     show Card, ListTile, Icons, Divider;

// import '../../bloc/app_setting_bloc.dart'
//     show AppSettingBloc, AppSettingState, AppSettingUpdateLocaleEvent;
// import '../../../../../app/helpers/extensions.dart'
//     show BuildContextLocalizationExtensions;

// class AppSettingLocaleWidget extends StatelessWidget {
//   const AppSettingLocaleWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocSignalSelector<AppSettingBloc, AppSettingState, Locale>(
//       selector: (state) => state.locale,
//       builder: (context, value) {
//         final appSettingBloc = context.read<AppSettingBloc>();

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 8, bottom: 8),
//               child: Text(
//                 'Language',
//                 style: context.theme.textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             Card(
//               elevation: 2,
//               margin: EdgeInsets.zero,
//               clipBehavior: Clip.antiAlias,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 children: AppLocalizations.supportedLocales.asMap().entries.map(
//                   (entry) {
//                     final locale = entry.value;
//                     final isSelected =
//                         locale.languageCode == value.languageCode;
//                     final isLast =
//                         entry.key ==
//                         AppLocalizations.supportedLocales.length - 1;
//                     final targetLocalizations = lookupAppLocalizations(locale);

//                     return Column(
//                       children: [
//                         ListTile(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 4,
//                           ),
//                           title: FutureBuilder<AppLocalizations>(
//                             future: targetLocalizations,
//                             builder: (context, snapshot) {
//                               // TODO: Loading
//                               if (snapshot.hasData) {
//                                 return Text(snapshot.data!.languageName);
//                               }
//                               return Text(locale.languageCode.toUpperCase());
//                             },
//                           ),
//                           trailing: isSelected
//                               ? const Icon(Icons.check, size: 18)
//                               : null,
//                           selected: isSelected,
//                           selectedTileColor: context.theme.colorScheme.primary
//                               .withOpacity(0.08),
//                           onTap: () {
//                             appSettingBloc.add(
//                               AppSettingUpdateLocaleEvent(locale),
//                             );
//                           },
//                         ),
//                         if (!isLast)
//                           const Divider(height: 1, indent: 16, endIndent: 16),
//                       ],
//                     );
//                   },
//                 ).toList(),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

/////////////////
///
///
///
import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart'
    show Card, Divider, ListTile, Icons;

import '../../bloc/app_setting_bloc.dart'
    show AppSettingBloc, AppSettingState, AppSettingUpdateLocaleEvent;
import '../../../../../app/helpers/extensions.dart'
    show BuildContextLocalizationExtensions;

class AppSettingLocaleWidget extends StatelessWidget {
  const AppSettingLocaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSignalSelector<AppSettingBloc, AppSettingState, Locale>(
      selector: (state) => state.locale,
      builder: (context, selectedLocale) {
        final bloc = context.read<AppSettingBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                'Language',
                style: context.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  for (final (index, locale)
                      in AppLocalizations.supportedLocales.indexed) ...[
                    _LocaleTile(
                      locale: locale,
                      selectedLocale: selectedLocale,
                      onTap: () {
                        bloc.add(AppSettingUpdateLocaleEvent(locale));
                      },
                    ),
                    if (index < AppLocalizations.supportedLocales.length - 1)
                      const Divider(height: 1, indent: 16, endIndent: 16),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LocaleTile extends StatefulWidget {
  const _LocaleTile({
    required this.locale,
    required this.selectedLocale,
    required this.onTap,
  });

  final Locale locale;
  final Locale selectedLocale;
  final VoidCallback onTap;

  @override
  State<_LocaleTile> createState() => _LocaleTileState();
}

class _LocaleTileState extends State<_LocaleTile> {
  String? _languageName;

  @override
  void initState() {
    super.initState();
    _loadLanguageName();
  }

  @override
  void didUpdateWidget(covariant _LocaleTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.locale != widget.locale) {
      _loadLanguageName();
    }
  }

  Future<void> _loadLanguageName() async {
    final localizations = await lookupAppLocalizations(widget.locale);

    if (!mounted) return;

    setState(() {
      _languageName = localizations.languageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.locale == widget.selectedLocale;

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(_languageName ?? widget.locale.languageCode.toUpperCase()),
      trailing: isSelected ? const Icon(Icons.check, size: 18) : null,
      selected: isSelected,
      selectedTileColor: context.theme.colorScheme.primary.withOpacity(0.08),
      onTap: widget.onTap,
    );
  }
}
