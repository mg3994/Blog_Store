part of 'router.dart';

class AppStackCodec implements KaiselStackCodec<AppRoute> {
  const AppStackCodec(this._dependencies, {this._appSettingBloc});
  final Dependencies _dependencies;
  final AppSettingBloc? _appSettingBloc;
  @override
  Uri encode(List<AppRoute> stack) {
    return switch (stack.last) {
      HomeRoute() => Uri(path: '/'),
      // ProductDetail(:final id) => Uri(path: '/products/$id'),
      // SettingsRoute() => Uri(path: '/settings'),
      // TODO: Handle this case.
      OnboardingRoute() => Uri(path: '/onboarding'),
      // TODO: Handle this case.
      SettingsMasterRoute() => Uri(path: '/settings'),
      // TODO: Handle this case.
      AppSettingRoute() => Uri(path: '/settings/app'),
      // TODO: Handle this case.
      ProductDetailRoute(:final id) => Uri(path: '/products/$id'),
    };
  }

  @override
  List<AppRoute>? decode(Uri uri) {
    _applyGlobalLanguage(uri);

    // return switch (uri.pathSegments) {
    //   [] || [''] => const [Home()],
    //   ['products', final id] => [const Home(), ProductDetail(id)],
    //   ['settings'] => const [Home(), Settings()],
    //   _ => null,
    // };
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
