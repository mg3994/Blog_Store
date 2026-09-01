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
                value: state.securityStorageConsentGranted,
                onChanged: null, // Security / Essential is non-untoggleable
                title: const Text('Security Storage'),
                subtitle: const Text(
                  'Essential security, authentication, and core app storage required for system operation.',
                ),
                secondary: const Icon(Icons.security_outlined),
              ),
              const Divider(),
              SwitchListTile(
                value: state.functionalityStorageConsentGranted,
                onChanged: null, // Functionality essential
                title: const Text('Functionality Storage'),
                subtitle: const Text(
                  'Stores local app settings, theme, and language choices.',
                ),
                secondary: const Icon(Icons.settings_suggest_outlined),
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
                          functionalityStorageConsentGranted:
                              state.functionalityStorageConsentGranted,
                          personalizationStorageConsentGranted:
                              state.personalizationStorageConsentGranted,
                          securityStorageConsentGranted:
                              state.securityStorageConsentGranted,
                        ),
                      );
                },
                title: const Text('Analytics Storage'),
                subtitle: const Text(
                  'Anonymous usage data to help us measure and improve app performance.',
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
                          functionalityStorageConsentGranted:
                              state.functionalityStorageConsentGranted,
                          personalizationStorageConsentGranted:
                              state.personalizationStorageConsentGranted,
                          securityStorageConsentGranted:
                              state.securityStorageConsentGranted,
                        ),
                      );
                },
                title: const Text('Ad Storage'),
                subtitle: const Text(
                  'Allows storage of advertising data and campaign performance metrics.',
                ),
                secondary: const Icon(Icons.campaign_outlined),
              ),
              const Divider(),
              SwitchListTile(
                value: state.adUserDataConsentGranted,
                onChanged: (value) {
                  context.read<AppSettingBloc>().add(
                        AppSettingUpdateConsentEvent(
                          hasGivenConsent: true,
                          analyticsStorageConsentGranted:
                              state.analyticsStorageConsentGranted,
                          adStorageConsentGranted:
                              state.adStorageConsentGranted,
                          adUserDataConsentGranted: value,
                          adPersonalizationSignalsConsentGranted:
                              state.adPersonalizationSignalsConsentGranted,
                          functionalityStorageConsentGranted:
                              state.functionalityStorageConsentGranted,
                          personalizationStorageConsentGranted:
                              state.personalizationStorageConsentGranted,
                          securityStorageConsentGranted:
                              state.securityStorageConsentGranted,
                        ),
                      );
                },
                title: const Text('Ad User Data'),
                subtitle: const Text(
                  'Allows consent for sending user data related to advertising.',
                ),
                secondary: const Icon(Icons.badge_outlined),
              ),
              const Divider(),
              SwitchListTile(
                value: state.adPersonalizationSignalsConsentGranted,
                onChanged: (value) {
                  context.read<AppSettingBloc>().add(
                        AppSettingUpdateConsentEvent(
                          hasGivenConsent: true,
                          analyticsStorageConsentGranted:
                              state.analyticsStorageConsentGranted,
                          adStorageConsentGranted:
                              state.adStorageConsentGranted,
                          adUserDataConsentGranted:
                              state.adUserDataConsentGranted,
                          adPersonalizationSignalsConsentGranted: value,
                          functionalityStorageConsentGranted:
                              state.functionalityStorageConsentGranted,
                          personalizationStorageConsentGranted:
                              state.personalizationStorageConsentGranted,
                          securityStorageConsentGranted:
                              state.securityStorageConsentGranted,
                        ),
                      );
                },
                title: const Text('Ad Personalization Signals'),
                subtitle: const Text(
                  'Enables personalized advertising signals and targeting.',
                ),
                secondary: const Icon(Icons.insights_outlined),
              ),
              const Divider(),
              SwitchListTile(
                value: state.personalizationStorageConsentGranted,
                onChanged: (value) {
                  context.read<AppSettingBloc>().add(
                        AppSettingUpdateConsentEvent(
                          hasGivenConsent: true,
                          analyticsStorageConsentGranted:
                              state.analyticsStorageConsentGranted,
                          adStorageConsentGranted:
                              state.adStorageConsentGranted,
                          adUserDataConsentGranted:
                              state.adUserDataConsentGranted,
                          adPersonalizationSignalsConsentGranted:
                              state.adPersonalizationSignalsConsentGranted,
                          functionalityStorageConsentGranted:
                              state.functionalityStorageConsentGranted,
                          personalizationStorageConsentGranted: value,
                          securityStorageConsentGranted:
                              state.securityStorageConsentGranted,
                        ),
                      );
                },
                title: const Text('Personalization Storage'),
                subtitle: const Text(
                  'Stores personal preferences for customized content and recommendations.',
                ),
                secondary: const Icon(Icons.person_pin_outlined),
              ),
            ],
          );
        },
      ),
    );
  }
}
