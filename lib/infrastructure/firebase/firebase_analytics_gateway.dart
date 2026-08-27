import 'package:firebase_analytics/firebase_analytics.dart';

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
}
