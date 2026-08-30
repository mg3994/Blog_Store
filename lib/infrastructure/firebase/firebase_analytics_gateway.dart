import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart' show PlatformException;

import '../../core/analytics/analytics_gateway.dart';

final class FirebaseAnalyticsGateway implements AnalyticsGateway {
  FirebaseAnalyticsGateway(this._analytics);

  final FirebaseAnalytics? _analytics;

  @override
  Future<void> logScreenView(String screenName) async {
    if (_analytics == null) return;

    // Using the supported check provided by the underlying platform interface
    if (!await _analytics.isSupported()) return;

    return _analytics.logScreenView(screenName: screenName);
  }

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    if (_analytics == null) return;
    if (!await _analytics.isSupported()) return;

    return _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  FirebaseAnalyticsObserver observer({
    ScreenNameExtractor nameExtractor = defaultNameExtractor,
    RouteFilter routeFilter = defaultRouteFilter,
    void Function(PlatformException error)? onError,
  }) {
    // If analytics is null, you'll want to pass a valid instance or handle it.
    // Note: FirebaseAnalyticsObserver doesn't take a future, so we rely on
    // the initialization guard when instantiating this class.
    return FirebaseAnalyticsObserver(
      analytics: _analytics ?? FirebaseAnalytics.instance,
      nameExtractor: nameExtractor,
      routeFilter: routeFilter,
      onError: onError,
    );
  }
}
