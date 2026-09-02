import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app_setting/presentation/bloc/app_setting_bloc.dart';
import 'analytics_consent_actions.dart';
import 'analytics_consent_header.dart';
import 'analytics_consent_preferences.dart';

class AnalyticsConsentModal extends StatefulWidget {
  const AnalyticsConsentModal({super.key});

  /// Shows the Modal Bottom Sheet if the user has not yet given consent.
  static Future<void> showIfNeeded(BuildContext context) async {
    final bloc = context.read<AppSettingBloc>();
    if (!bloc.stateValue.hasGivenConsent) {
      await show(context);
    }
  }

  /// Explicitly shows the Analytics Consent Modal Bottom Sheet.
  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AnalyticsConsentModal(),
    );
  }

  @override
  State<AnalyticsConsentModal> createState() => _AnalyticsConsentModalState();
}

class _AnalyticsConsentModalState extends State<AnalyticsConsentModal> {
  bool _showSettingsSelection = false;
  bool _analyticsConsent = true;
  bool _advertisingConsent = true;
  bool _personalizationConsent = true;

  void _onAcceptAll() {
    context.read<AppSettingBloc>().add(
      const AppSettingUpdateConsentEvent(
        hasGivenConsent: true,
        analyticsStorageConsentGranted: true,
        adStorageConsentGranted: true,
        adUserDataConsentGranted: true,
        adPersonalizationSignalsConsentGranted: true,
        functionalityStorageConsentGranted: true,
        personalizationStorageConsentGranted: true,
        securityStorageConsentGranted: true,
      ),
    );
    Navigator.of(context).maybePop();
  }

  void _onAcceptSelected() {
    context.read<AppSettingBloc>().add(
      AppSettingUpdateConsentEvent(
        hasGivenConsent: true,
        analyticsStorageConsentGranted: _analyticsConsent,
        adStorageConsentGranted: _advertisingConsent,
        adUserDataConsentGranted: _advertisingConsent,
        adPersonalizationSignalsConsentGranted: _advertisingConsent,
        functionalityStorageConsentGranted: true,
        personalizationStorageConsentGranted: _personalizationConsent,
        securityStorageConsentGranted: true,
      ),
    );
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AnalyticsConsentHeader(),
              const SizedBox(height: 20),
              if (_showSettingsSelection) ...[
                AnalyticsConsentPreferences(
                  analyticsConsent: _analyticsConsent,
                  advertisingConsent: _advertisingConsent,
                  personalizationConsent: _personalizationConsent,
                  onAnalyticsChanged: (val) {
                    setState(() {
                      _analyticsConsent = val;
                    });
                  },
                  onAdvertisingChanged: (val) {
                    setState(() {
                      _advertisingConsent = val;
                    });
                  },
                  onPersonalizationChanged: (val) {
                    setState(() {
                      _personalizationConsent = val;
                    });
                  },
                ),
                const SizedBox(height: 24),
              ],
              AnalyticsConsentActions(
                showSettingsSelection: _showSettingsSelection,
                onAcceptAll: _onAcceptAll,
                onAcceptSelected: _onAcceptSelected,
                onOpenSettings: () {
                  setState(() {
                    _showSettingsSelection = true;
                  });
                },
                onBackFromSettings: () {
                  setState(() {
                    _showSettingsSelection = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
