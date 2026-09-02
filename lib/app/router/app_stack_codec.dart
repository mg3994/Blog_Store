part of 'router.dart';

final class AppStackCodec implements KaiselConfigCodec<AppRoute> {
  const AppStackCodec(this._dependencies, {this._appSettingBloc});

  final Dependencies _dependencies;
  final AppSettingBloc? _appSettingBloc;

  @override
  KaiselConfig<AppRoute>? decode(Uri uri) {
    _applyGlobalLanguage(uri);

    return switch (uri.pathSegments) {
      // Home
      [] || [''] => KaiselConfig(mainStack: [HomeRoot()]),

      // Onboarding
      ['onboarding'] => KaiselConfig(mainStack: [OnboardingRoute()]),

      // Home → Product detail
      ['products', final id] => KaiselConfig(
        mainStack: [const HomeRoot(), ProductDetailRoute(id)],
      ),

      // Settings
      ['settings'] => KaiselConfig(mainStack: [SettingsMasterRoute()]),

      // Settings → App settings
      ['settings', 'app'] => KaiselConfig(
        mainStack: [SettingsMasterRoute(), AppSettingRoute()],
      ),

      _ => null,
    };
  }

  @override
  Uri encode(KaiselConfig<AppRoute> config) {
    final top = config.mainStack.last;

    return switch (top) {
      HomeRoot() => Uri(path: '/'),

      OnboardingRoute() => Uri(path: '/onboarding'),

      ProductDetailRoute(:final id) => Uri(path: '/products/$id'),

      SettingsMasterRoute() => Uri(path: '/settings'),

      AppSettingRoute() => Uri(path: '/settings/app'),
      // TODO: Handle this case.
      GeneralSettingRoute() => throw UnimplementedError(),
      // TODO: Handle this case.
      NotificationsSettingRoute() => throw UnimplementedError(),
      // TODO: Handle this case.
      PrivacySettingRoute() => throw UnimplementedError(),
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
