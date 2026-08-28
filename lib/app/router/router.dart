import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/app/helpers/extensions.dart';
import 'package:blogstore/features/app_setting/presentation/bloc/settings_bloc.dart';
import 'package:blogstore/features/app_setting/presentation/pages/settings_screen.dart';
import 'package:blogstore/injection/dependency_injection.dart'
    show Dependencies;
import 'package:kaisel/kaisel.dart';
import 'package:material_ui/material_ui.dart';

// 1. Sealed Route Hierarchy
sealed class AppRoute extends KaiselRoute {
  const AppRoute();
}

final class HomeRoute extends AppRoute {
  const HomeRoute();
}

final class SettingsRoute extends AppRoute {
  const SettingsRoute();
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
      SettingsRoute() => const SettingsScreen(),
      ProductDetailRoute(:final id) => ProductDetailScreen(id: id),
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
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => context.navigator.push(const SettingsRoute()),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: IconButton(
          onPressed: () => context.read<SettingsBloc>().add(
            const SettingsUpdateSeedColorEvent(Colors.red),
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
