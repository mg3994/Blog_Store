import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/app/helpers/extensions.dart';

import 'package:blogstore/injection/dependency_injection.dart'
    show Dependencies;
import 'package:kaisel/kaisel.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/app_setting/app_setting.dart' show AppSettingScreen;
import '../../features/app_setting/presentation/bloc/app_setting_bloc.dart'
    show AppSettingBloc, AppSettingUpdateSeedColorEvent;

// 1. Sealed Route Hierarchy
sealed class AppRoute extends KaiselRoute {
  const AppRoute();
}

final class AppSettingRoute extends AppRoute {
  const AppSettingRoute();
}

final class HomeRoute extends AppRoute {
  const HomeRoute();
}

final class ProductDetailRoute extends AppRoute {
  final String id;
  const ProductDetailRoute(this.id);
}

// 2. Class-Based Router accepting Dependencies
final class AppRouter {
  const AppRouter(this._dependencies);

  final Dependencies _dependencies;

  KaiselRouterConfig<AppRoute> createConfig() {
    return KaiselRouterConfig<AppRoute>(
      initial: const HomeRoute(),
      observers: () => [_dependencies.analyticsGateway.observer()],
      onScreenChanged: (route) =>
          _dependencies.analyticsGateway.logScreenView(route.routeName),
      builder: _buildRoute,
    );
  }

  Widget _buildRoute(BuildContext context, AppRoute route) {
    return switch (route) {
      HomeRoute() => const HomeScreen(),
      ProductDetailRoute(:final id) => ProductDetailScreen(id: id),
      AppSettingRoute() => const AppSettingScreen(),
    };
  }
}

// 3. Decoupled Screen Views
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () => context.push(const AppSettingRoute()),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        color: context.theme.colorScheme.primary,
        child: IconButton(
          onPressed: () => context.read<AppSettingBloc>().add(
            AppSettingUpdateSeedColorEvent(Colors.red),
          ),
          icon: const Icon(Icons.color_lens),
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Placeholder(key: Key(id));
  }
}
