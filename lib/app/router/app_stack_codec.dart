part of 'router.dart';

final class AppStackCodec implements KaiselConfigCodec<AppRoute> {
  const AppStackCodec(this._dependencies, {this._appSettingBloc});

  final Dependencies _dependencies;
  final AppSettingBloc? _appSettingBloc;

  static const _homeBranch = 0;
  static const _settingsBranch = 3;

  @override
  KaiselConfig<AppRoute>? decode(Uri uri) {
    debugPrint('🔥 DECODE URI = $uri');

    _applyGlobalLanguage(uri);

    final segments = uri.pathSegments
        .where((segment) => segment.isNotEmpty)
        .toList(growable: false);

    return switch (segments) {
      // `/` is state-dependent:
      //
      // onboarding incomplete -> OnboardingRoute
      // onboarding complete   -> Home
      [] => _rootConfig(),

      // Explicit onboarding URL always means onboarding.
      ['onboarding'] => _onboardingConfig(),

      // Home
      ['products', final id] => _productConfig(id),

      // Settings
      ['settings'] => _settingsConfig(),
      ['settings', 'appearance'] => _appearanceConfig(),
      ['settings', 'general'] => _generalSettingsConfig(),
      ['settings', 'notifications'] => _notificationsConfig(),
      ['settings', 'privacy'] => _privacyConfig(),

      // Unknown URL.
      _ => null,
    };
  }

  /// Resolves the root URL `/`.
  ///
  /// The root URL is special because it does not identify a concrete
  /// destination by itself. Its destination depends on onboarding state.
  KaiselConfig<AppRoute> _rootConfig() {
    final hasCompletedOnboarding =
        _appSettingBloc?.stateValue.hasCompletedOnboarding ?? false;

    debugPrint(
      '🔥 ROOT CONFIG → '
      '${hasCompletedOnboarding ? 'Home' : 'Onboarding'}',
    );

    return hasCompletedOnboarding ? _homeConfig() : _onboardingConfig();
  }

  KaiselConfig<AppRoute> _onboardingConfig() {
    return KaiselConfig(mainStack: [OnboardingRoute()]);
  }

  KaiselConfig<AppRoute> _homeConfig() {
    return KaiselConfig(
      mainStack: [MainShellRoute()],
      nestedState: KaiselShellConfig(
        activeBranch: _homeBranch,
        activeBranchStack: [HomeRoot()],
      ),
    );
  }

  KaiselConfig<AppRoute> _productConfig(String id) {
    return KaiselConfig(
      mainStack: const [MainShellRoute()],
      nestedState: KaiselShellConfig(
        activeBranch: _homeBranch,
        activeBranchStack: [HomeRoot(), ProductDetailRoute(id)],
      ),
    );
  }

  KaiselConfig<AppRoute> _settingsConfig() {
    return KaiselConfig(
      mainStack: [MainShellRoute()],
      nestedState: KaiselShellConfig(
        activeBranch: _settingsBranch,
        activeBranchStack: [SettingsMasterRoute()],
      ),
    );
  }

  KaiselConfig<AppRoute> _appearanceConfig() {
    return KaiselConfig(
      mainStack: [MainShellRoute()],
      nestedState: KaiselShellConfig(
        activeBranch: _settingsBranch,
        activeBranchStack: [SettingsMasterRoute(), AppSettingRoute()],
      ),
    );
  }

  KaiselConfig<AppRoute> _generalSettingsConfig() {
    return KaiselConfig(
      mainStack: [MainShellRoute()],
      nestedState: KaiselShellConfig(
        activeBranch: _settingsBranch,
        activeBranchStack: [SettingsMasterRoute(), GeneralSettingRoute()],
      ),
    );
  }

  KaiselConfig<AppRoute> _notificationsConfig() {
    return KaiselConfig(
      mainStack: [MainShellRoute()],
      nestedState: KaiselShellConfig(
        activeBranch: _settingsBranch,
        activeBranchStack: [SettingsMasterRoute(), NotificationsSettingRoute()],
      ),
    );
  }

  KaiselConfig<AppRoute> _privacyConfig() {
    return KaiselConfig(
      mainStack: [MainShellRoute()],
      nestedState: KaiselShellConfig(
        activeBranch: _settingsBranch,
        activeBranchStack: [SettingsMasterRoute(), PrivacySettingRoute()],
      ),
    );
  }

  @override
  Uri encode(KaiselConfig<AppRoute> config) {
    final uri = switch ((config.mainStack.last, config.nestedState)) {
      // Onboarding.
      (OnboardingRoute(), _) => Uri(path: '/onboarding'),

      // Main shell.
      (
        MainShellRoute(),
        KaiselShellConfig(
          activeBranch: final branch,
          activeBranchStack: final stack,
        ),
      ) =>
        switch (branch) {
          _homeBranch => _encodeHome(stack),
          _settingsBranch => _encodeSettings(stack),
          _ => Uri(path: '/'),
        },

      // Fallback.
      _ => Uri(path: '/'),
    };

    debugPrint(
      '🔥 ENCODE '
      '${config.mainStack.map((route) => route.routeName).toList()} '
      '→ $uri',
    );

    return uri;
  }

  Uri _encodeHome(List<KaiselRoute> stack) {
    return switch (stack) {
      [HomeRoot()] => Uri(path: '/'),

      [HomeRoot(), ProductDetailRoute(:final id)] => Uri(path: '/products/$id'),

      _ => Uri(path: '/'),
    };
  }

  Uri _encodeSettings(List<KaiselRoute> stack) {
    return switch (stack) {
      [SettingsMasterRoute()] => Uri(path: '/settings'),

      [SettingsMasterRoute(), AppSettingRoute()] => Uri(
        path: '/settings/appearance',
      ),

      [SettingsMasterRoute(), GeneralSettingRoute()] => Uri(
        path: '/settings/general',
      ),

      [SettingsMasterRoute(), NotificationsSettingRoute()] => Uri(
        path: '/settings/notifications',
      ),

      [SettingsMasterRoute(), PrivacySettingRoute()] => Uri(
        path: '/settings/privacy',
      ),

      _ => Uri(path: '/settings'),
    };
  }

  void _applyGlobalLanguage(Uri uri) {
    final globalLanguage = uri.queryParameters['gl'];

    if (globalLanguage == null || globalLanguage.isEmpty) {
      return;
    }

    final languageCode = globalLanguage.split('_').first.toLowerCase();

    final supported = AppLocalizations.supportedLocales.any(
      (locale) => locale.languageCode.toLowerCase() == languageCode,
    );

    if (!supported) {
      return;
    }

    _appSettingBloc?.add(
      AppSettingTemporarilyChangeLocaleEvent(
        Locale.fromSubtags(languageCode: languageCode),
      ),
    );
  }
}
