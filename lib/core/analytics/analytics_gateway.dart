abstract interface class AnalyticsGateway {
  Future<void> logScreenView(String screenName);

  Future<void> logEvent(String name, {Map<String, Object>? parameters});
}
