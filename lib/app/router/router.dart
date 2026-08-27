// 1. Alias the type for convenience
import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalyticsObserver, FirebaseAnalytics;
import 'package:kaisel/kaisel.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/analytics/analytics_gateway.dart' show AnalyticsGateway;

typedef AppRouterConfig<T extends KaiselRoute> = KaiselRouterConfig<T>;

// 2. Define your app routes (sealed class recommended for pattern matching)
sealed class AppRoute extends KaiselRoute {
  const AppRoute();
}

final class HomeRoute extends AppRoute {
  const HomeRoute();
}

final class ProductDetailRoute extends AppRoute {
  final String id;
  const ProductDetailRoute(this.id);
}

// 3. Instantiate the configuration
AppRouterConfig<AppRoute> createRouterConfig(
  AnalyticsGateway analyticsGateway,
) => AppRouterConfig<AppRoute>(
  observers: () => [
    FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
  ],
  onScreenChanged: (route) => analyticsGateway.logScreenView(route.routeName),
  onTransition: (from, to) {
    if (to.isNotEmpty) {
      analyticsGateway.logScreenView(to.last.routeName);
    }
  },
  initial: const HomeRoute(),
  builder: (context, route) => switch (route) {
    HomeRoute() => Placeholder(),
    ProductDetailRoute(:final id) => Placeholder(key: Key(id)),
  },
);
