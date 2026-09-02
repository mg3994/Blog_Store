part of 'router.dart';

final class AppStackCodec implements KaiselConfigCodec<AppRoute> {
  const AppStackCodec(this._dependencies, {this._appSettingBloc});

  final Dependencies _dependencies;
  final AppSettingBloc? _appSettingBloc;

  static const _homeBranch = 0;
  static const _settingsBranch = 3;

  @override
  KaiselConfig<AppRoute>? decode(Uri uri) {
    _applyGlobalLanguage(uri);

    final segments = uri.pathSegments
        .where((segment) => segment.isNotEmpty)
        .toList();

    return switch (segments) {
      // ---------------------------------------------------------------------
      // Home
      // ---------------------------------------------------------------------

      [] => KaiselConfig(
        mainStack: const [MainShellRoute()],
        nestedState: KaiselShellConfig(
          activeBranch: _homeBranch,
          activeBranchStack: [HomeRoot()],
        ),
      ),

      // ---------------------------------------------------------------------
      // Onboarding
      // ---------------------------------------------------------------------
      ['onboarding'] => KaiselConfig(mainStack: const [OnboardingRoute()]),

      // ---------------------------------------------------------------------
      // Home → Product
      // ---------------------------------------------------------------------
      ['products', final id] => KaiselConfig(
        mainStack: const [MainShellRoute()],
        nestedState: KaiselShellConfig(
          activeBranch: _homeBranch,
          activeBranchStack: [HomeRoot(), ProductDetailRoute(id)],
        ),
      ),

      // ---------------------------------------------------------------------
      // Settings
      // ---------------------------------------------------------------------
      ['settings'] => KaiselConfig(
        mainStack: const [MainShellRoute()],
        nestedState: KaiselShellConfig(
          activeBranch: _settingsBranch,
          activeBranchStack: [SettingsMasterRoute()],
        ),
      ),

      // ---------------------------------------------------------------------
      // Settings → Appearance
      // ---------------------------------------------------------------------
      ['settings', 'appearance'] => KaiselConfig(
        mainStack: const [MainShellRoute()],
        nestedState: KaiselShellConfig(
          activeBranch: _settingsBranch,
          activeBranchStack: [SettingsMasterRoute(), AppSettingRoute()],
        ),
      ),

      // ---------------------------------------------------------------------
      // Settings → General
      // ---------------------------------------------------------------------
      ['settings', 'general'] => KaiselConfig(
        mainStack: const [MainShellRoute()],
        nestedState: KaiselShellConfig(
          activeBranch: _settingsBranch,
          activeBranchStack: [SettingsMasterRoute(), GeneralSettingRoute()],
        ),
      ),

      // ---------------------------------------------------------------------
      // Settings → Notifications
      // ---------------------------------------------------------------------
      ['settings', 'notifications'] => KaiselConfig(
        mainStack: const [MainShellRoute()],
        nestedState: KaiselShellConfig(
          activeBranch: _settingsBranch,
          activeBranchStack: [
            SettingsMasterRoute(),
            NotificationsSettingRoute(),
          ],
        ),
      ),

      // ---------------------------------------------------------------------
      // Settings → Privacy
      // ---------------------------------------------------------------------
      ['settings', 'privacy'] => KaiselConfig(
        mainStack: const [MainShellRoute()],
        nestedState: KaiselShellConfig(
          activeBranch: _settingsBranch,
          activeBranchStack: [SettingsMasterRoute(), PrivacySettingRoute()],
        ),
      ),

      _ => null,
    };
  }

  @override
  Uri encode(KaiselConfig<AppRoute> config) {
    return switch ((config.mainStack.last, config.nestedState)) {
      // ---------------------------------------------------------------------
      // Onboarding
      // ---------------------------------------------------------------------

      (OnboardingRoute(), _) => Uri(path: '/onboarding'),

      // ---------------------------------------------------------------------
      // Main shell
      // ---------------------------------------------------------------------
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

      // Defensive fallback.
      (MainShellRoute(), _) => Uri(path: '/'),

      _ => Uri(path: '/'),
    };
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
