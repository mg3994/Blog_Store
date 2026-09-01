import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/app/router/router.dart';
import 'package:blogstore/injection/dependency_injection.dart';
import 'package:kaisel/kaisel.dart';
import 'package:material_ui/material_ui.dart';

import '../../../settings/app_setting/presentation/bloc/app_setting_bloc.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  bool _analyticsConsent = true;
  bool _advertisingConsent = true;
  bool _showSettingsSelection = false;

  void _onAcceptAllConsent() {
    context.read<AppSettingBloc>().add(
          const AppSettingUpdateConsentEvent(
            hasGivenConsent: true,
            analyticsStorageConsentGranted: true,
            adStorageConsentGranted: true,
            adUserDataConsentGranted: true,
            adPersonalizationSignalsConsentGranted: true,
          ),
        );
    context.dependencies.analyticsGateway.logTutorialBegin();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onAcceptSelectedConsent() {
    context.read<AppSettingBloc>().add(
          AppSettingUpdateConsentEvent(
            hasGivenConsent: true,
            analyticsStorageConsentGranted: _analyticsConsent,
            adStorageConsentGranted: _advertisingConsent,
            adUserDataConsentGranted: _advertisingConsent,
            adPersonalizationSignalsConsentGranted: _advertisingConsent,
          ),
        );
    if (_analyticsConsent) {
      context.dependencies.analyticsGateway.logTutorialBegin();
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() {
    if (_currentPage == 0) {
      _onAcceptAllConsent();
      return;
    }

    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    final bloc = context.read<AppSettingBloc>();
    if (!bloc.stateValue.hasGivenConsent) {
      _onAcceptAllConsent();
    }
    bloc.add(const AppSettingCompleteOnboardingEvent());
    context.set(const [HomeRoute()]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLastPage = _currentPage == 3;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: const Text('Skip'),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  // Page 0: Cookie & Privacy Consent Slide
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.cookie_outlined,
                                size: 64,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'We use cookies & data',
                              style: theme.textTheme.headlineMedium?.copyWith(
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
                                        'These enhance site performance, gather anonymous analytics, and power personalized recommendations. Learn more in our ',
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
                            const SizedBox(height: 24),
                            if (_showSettingsSelection) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Switch(
                                          value: true,
                                          onChanged: null,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Necessary',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
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
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
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
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          _showSettingsSelection = false;
                                        });
                                      },
                                      child: const Text('Back'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: _onAcceptSelectedConsent,
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
                                      child: const Text('Settings'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: _onAcceptAllConsent,
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
                  ),

                  // Page 1: Welcome
                  const _OnboardingPageWidget(
                    icon: Icons.storefront_outlined,
                    title: 'Welcome to BlogStore',
                    description:
                        'Discover curated blog posts, articles, and products all in one seamless app.',
                  ),

                  // Page 2: Offline-First
                  const _OnboardingPageWidget(
                    icon: Icons.sync_outlined,
                    title: 'Offline-First Experience',
                    description:
                        'Access your favorite articles and store catalog anytime, even without an active internet connection.',
                  ),

                  // Page 3: Privacy
                  const _OnboardingPageWidget(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Your Privacy Matters',
                    description:
                        'Customize your app experience, locale, appearance, and privacy choices anytime in Settings.',
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == 0
                        ? 'Continue'
                        : (isLastPage ? 'Get Started' : 'Next'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageWidget extends StatelessWidget {
  const _OnboardingPageWidget({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 80,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
