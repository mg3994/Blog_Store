part of 'router.dart';

class AppStackCodec implements KaiselStackCodec<AppRoute> {
  const AppStackCodec(this._dependencies, {AppSettingBloc? appSettingBloc})
      : _appSettingBloc = appSettingBloc;
  final Dependencies _dependencies;
  final AppSettingBloc? _appSettingBloc;
  @override
  Uri encode(List<AppRoute> stack) {
    return switch (stack.last) {
      OnboardingRoute() => Uri(path: '/onboarding'),
      HomeRoute() => Uri(path: '/'),
      ProductDetailRoute(:final id) => Uri(path: '/products/$id'),
      SettingsMasterRoute() || AppSettingRoute() || PrivacySettingRoute() =>
        Uri(path: '/settings'),
    };
  }

  @override
  List<AppRoute>? decode(Uri uri) {
    _applyGlobalLanguage(uri);

    final hasCompletedOnboarding =
        _appSettingBloc?.stateValue.hasCompletedOnboarding ?? false;

    return switch (uri.pathSegments) {
      ['onboarding'] => const [OnboardingRoute()],
      [] || [''] => hasCompletedOnboarding
          ? const [HomeRoute()]
          : const [OnboardingRoute()],
      ['products', final id] => [
        hasCompletedOnboarding
            ? const HomeRoute()
            : const OnboardingRoute(),
        ProductDetailRoute(id),
      ],
      ['settings'] => [
        hasCompletedOnboarding
            ? const HomeRoute()
            : const OnboardingRoute(),
        const SettingsMasterRoute(),
      ],
      _ => null,
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

    // Update locale through your AppSettingBloc.
    _appSettingBloc?.add(
      AppSettingTemporarilyChangeLocaleEvent(
        Locale.fromSubtags(languageCode: languageCode),
      ),
    );
  }
}
