// 1. Alias the type for convenience

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/app/helpers/extensions.dart';
import 'package:blogstore/app/settings/bloc/settings_bloc.dart';
import 'package:kaisel/kaisel.dart';
import 'package:material_ui/material_ui.dart';

import '../../injection/dependency_injection.dart' show Dependencies;

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
AppRouterConfig<AppRoute> createRouterConfig(Dependencies dependencies) =>
    AppRouterConfig<AppRoute>(
      observers: () => [dependencies.analyticsGateway.observer()],
      onScreenChanged: (route) =>
          dependencies.analyticsGateway.logScreenView(route.routeName),
      onTransition: (from, to) {
        if (to.isNotEmpty) {
          dependencies.analyticsGateway.logScreenView(to.last.routeName);
        }
      },
      initial: const HomeRoute(),
      builder: (context, route) => switch (route) {
        HomeRoute() => Scaffold(
          appBar: AppBar(backgroundColor: context.theme.colorScheme.primary),
          body: Container(
            color: context.theme.colorScheme.primary,
            child: IconButton(
              onPressed: () => context.read<SettingsBloc>().add(
                SettingsUpdateSeedColorEvent(Colors.red),
              ),
              icon: Icon(Icons.color_lens),
            ),
          ),
        ),
        ProductDetailRoute(:final id) => Placeholder(key: Key(id)),
      },
    );
