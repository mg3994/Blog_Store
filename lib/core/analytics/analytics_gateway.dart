import 'package:firebase_analytics/firebase_analytics.dart'
    show
        FirebaseAnalytics,
        ScreenNameExtractor,
        defaultNameExtractor,
        defaultRouteFilter;
import 'package:firebase_analytics/observer.dart'
    show FirebaseAnalyticsObserver, RouteFilter;
import 'package:flutter/services.dart' show PlatformException;

abstract interface class AnalyticsGateway {
  Future<void> logScreenView(String screenName);

  Future<void> logEvent(String name, {Map<String, Object>? parameters});

  FirebaseAnalyticsObserver observer({
    ScreenNameExtractor nameExtractor = defaultNameExtractor,
    RouteFilter routeFilter = defaultRouteFilter,
    void Function(PlatformException error)? onError,
  });
}
