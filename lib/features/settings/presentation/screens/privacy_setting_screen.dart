import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/app/helpers/extensions.dart';
import 'package:kaisel/kaisel.dart';
import 'package:material_ui/material_ui.dart';

import '../../app_setting/presentation/bloc/app_setting_bloc.dart';

class PrivacySettingScreen extends StatelessWidget {
  const PrivacySettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isOnlyPage = KaiselPageScope.maybeOf(context)?.isBottom ?? true;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !isOnlyPage,
        title: Text(context.l10n.settingsPrivacyTitle),
        backgroundColor: colorScheme.surface,
      ),
      body: BlocSignalBuilder<AppSettingBloc, AppSettingState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHigh,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data & Privacy Preferences',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Control how data and analytics performance measurements are stored and shared.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: true,
                onChanged: null, // Essential / Necessary is non-untoggleable
                title: const Text('Necessary Stuffs'),
                subtitle: const Text(
                  'Essential core app functionality and security storage. Required for the app to function.',
                ),
                secondary: const Icon(Icons.security_outlined),
              ),
              const Divider(),
              SwitchListTile(
                value: state.analyticsStorageConsentGranted,
                onChanged: (value) {
                  context.read<AppSettingBloc>().add(
                        AppSettingUpdateConsentEvent(
                          hasGivenConsent: true,
                          analyticsStorageConsentGranted: value,
                          adStorageConsentGranted:
                              state.adStorageConsentGranted,
                          adUserDataConsentGranted:
                              state.adUserDataConsentGranted,
                          adPersonalizationSignalsConsentGranted:
                              state.adPersonalizationSignalsConsentGranted,
                        ),
                      );
                },
                title: const Text('Analytics'),
                subtitle: const Text(
                  'Anonymous usage data to help us measure and improve site performance.',
                ),
                secondary: const Icon(Icons.analytics_outlined),
              ),
              const Divider(),
              SwitchListTile(
                value: state.adStorageConsentGranted,
                onChanged: (value) {
                  context.read<AppSettingBloc>().add(
                        AppSettingUpdateConsentEvent(
                          hasGivenConsent: true,
                          analyticsStorageConsentGranted:
                              state.analyticsStorageConsentGranted,
                          adStorageConsentGranted: value,
                          adUserDataConsentGranted: value,
                          adPersonalizationSignalsConsentGranted: value,
                        ),
                      );
                },
                title: const Text('Advertising & Personalization'),
                subtitle: const Text(
                  'Personalized recommendations and ad signals measurement.',
                ),
                secondary: const Icon(Icons.campaign_outlined),
              ),
            ],
          );
        },
      ),
    );
  }
}
