import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart' show PlatformException;

import '../../core/analytics/analytics_gateway.dart';

final class FirebaseAnalyticsGateway implements AnalyticsGateway {
  FirebaseAnalyticsGateway(this._analytics);

  final FirebaseAnalytics _analytics;

  @override
  Future<void> logScreenView(String screenName) {
    return _analytics.logScreenView(screenName: screenName);
  }

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) {
    return _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  FirebaseAnalyticsObserver observer({
    ScreenNameExtractor nameExtractor = defaultNameExtractor,
    RouteFilter routeFilter = defaultRouteFilter,
    void Function(PlatformException error)? onError,
  }) => FirebaseAnalyticsObserver(
    analytics: _analytics,
    nameExtractor: nameExtractor,
    routeFilter: routeFilter,
    onError: onError,
  );
}
