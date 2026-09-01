import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:material_ui/material_ui.dart';

import '../../../settings/app_setting/presentation/bloc/app_setting_bloc.dart';

class AnalyticsConsentModal extends StatefulWidget {
  const AnalyticsConsentModal({super.key});

  static Future<void> showIfNeeded(BuildContext context) async {
    final bloc = context.read<AppSettingBloc>();
    if (!bloc.stateValue.hasGivenConsent) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AnalyticsConsentModal(),
      );
    }
  }

  @override
  State<AnalyticsConsentModal> createState() => _AnalyticsConsentModalState();
}

class _AnalyticsConsentModalState extends State<AnalyticsConsentModal> {
  bool _showSettingsSelection = false;
  bool _analyticsConsent = true;
  bool _advertisingConsent = true;

  void _onAcceptAll() {
    context.read<AppSettingBloc>().add(
          const AppSettingUpdateConsentEvent(
            hasGivenConsent: true,
            analyticsStorageConsentGranted: true,
            adStorageConsentGranted: true,
            adUserDataConsentGranted: true,
            adPersonalizationSignalsConsentGranted: true,
          ),
        );
    Navigator.of(context).pop();
  }

  void _onAcceptSelected() {
    context.read<AppSettingBloc>().add(
          AppSettingUpdateConsentEvent(
            hasGivenConsent: true,
            analyticsStorageConsentGranted: _analyticsConsent,
            adStorageConsentGranted: _advertisingConsent,
            adUserDataConsentGranted: _advertisingConsent,
            adPersonalizationSignalsConsentGranted: _advertisingConsent,
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We use cookies',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          'These are small text files that enhance site performance, gather anonymous data, and show personalized ads. Learn more in our ',
                    ),
                    TextSpan(
                      text: 'privacy policy',
                      style: TextStyle(
                        color: colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_showSettingsSelection) ...[
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Switch(
                            value: true,
                            onChanged: null, // Disabled necessary switch
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Necessary',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Switch(
                            value: _analyticsConsent,
                            onChanged: (val) {
                              setState(() {
                                _analyticsConsent = val;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Analytics',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Switch(
                      value: _advertisingConsent,
                      onChanged: (val) {
                        setState(() {
                          _advertisingConsent = val;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Advertising',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _showSettingsSelection = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _onAcceptSelected,
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _showSettingsSelection = true;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Settings'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _onAcceptAll,
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Accept all'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
