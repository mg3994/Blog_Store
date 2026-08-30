import 'dart:ui' show DisplayFeature, DisplayFeatureType;
import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/app/helpers/extensions.dart';
import 'package:blogstore/app/widgets/app_navigation_shell.dart';
import 'package:blogstore/injection/dependency_injection.dart' show Dependencies;
import 'package:kaisel/kaisel.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/settings/settings.dart';
import '../../features/settings/app_setting/presentation/bloc/app_setting_bloc.dart'
    show AppSettingBloc, AppSettingUpdateSeedColorEvent;

// 1. Sealed Route Hierarchy
sealed class AppRoute extends KaiselRoute {
  const AppRoute();
}

final class SettingsMasterRoute extends AppRoute {
  const SettingsMasterRoute();
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

/// Helper function to detect a vertical fold / hinge
DisplayFeature? _verticalFold(MediaQueryData mq) {
  for (final f in mq.displayFeatures) {
    final vertical = f.bounds.left > 0 && f.bounds.height >= mq.size.height * 0.9;
    final isFold = f.type == DisplayFeatureType.fold || f.type == DisplayFeatureType.hinge;
    if (vertical && isFold) return f;
  }
  return null;
}

// 2. Class-Based Router accepting Dependencies
final class AppRouter {
  const AppRouter(this._dependencies);

  final Dependencies _dependencies;

  KaiselRouterConfig<AppRoute> createConfig() {
    return KaiselRouterConfig<AppRoute>.adaptive(
      initial: const HomeRoute(),
      observers: () => [_dependencies.analyticsGateway.observer()],
      onScreenChanged: (route) =>
          _dependencies.analyticsGateway.logScreenView(route.routeName),
      builder: _buildRoute,
    );
  }

  KaiselPageResult _buildRoute(
    BuildContext context,
    AppRoute route,
    KaiselStackContext<AppRoute> ctx,
  ) {
    final mq = MediaQuery.of(context);
    final fold = _verticalFold(mq);
    final spanned = fold != null || mq.size.width >= 700;

    return switch ((ctx.previous, route, spanned)) {
      // Wide / Foldable screens (Master -> Detail)
      (SettingsMasterRoute(), AppSettingRoute(), true) => KaiselAbsorbingPage(
          widget: AppNavigationShell(
            currentRoute: route,
            child: Builder(
              builder: (navContext) => SettingsTwoPane(
                master: SettingsMasterScreen(
                  selectedSetting: 'appearance',
                  onSelectSetting: (setting) {
                    if (setting == 'appearance') {
                      navContext.pushOrReplaceTop(const AppSettingRoute());
                    }
                  },
                ),
                detail: const AppSettingScreen(),
                hinge: fold?.bounds,
              ),
            ),
          ),
        ),
      (_, AppSettingRoute(), true) => KaiselStandalonePage(
          AppNavigationShell(
            currentRoute: route,
            child: Builder(
              builder: (navContext) => SettingsTwoPane(
                master: SettingsMasterScreen(
                  selectedSetting: 'appearance',
                  onSelectSetting: (setting) {
                    if (setting == 'appearance') {
                      navContext.pushOrReplaceTop(const AppSettingRoute());
                    }
                  },
                ),
                detail: const AppSettingScreen(),
                hinge: fold?.bounds,
              ),
            ),
          ),
        ),
      (_, SettingsMasterRoute(), true) => KaiselStandalonePage(
          AppNavigationShell(
            currentRoute: route,
            child: Builder(
              builder: (navContext) => SettingsTwoPane(
                master: SettingsMasterScreen(
                  selectedSetting: 'appearance',
                  onSelectSetting: (setting) {
                    if (setting == 'appearance') {
                      navContext.pushOrReplaceTop(const AppSettingRoute());
                    }
                  },
                ),
                detail: const AppSettingScreen(),
                hinge: fold?.bounds,
              ),
            ),
          ),
        ),

      // Single pane compact screens: Standalone page push/pop
      (_, AppSettingRoute(), false) => KaiselStandalonePage(
          AppNavigationShell(
            currentRoute: route,
            child: const AppSettingScreen(),
          ),
        ),
      (_, SettingsMasterRoute(), false) => KaiselStandalonePage(
          AppNavigationShell(
            currentRoute: route,
            child: Builder(
              builder: (navContext) => SettingsMasterScreen(
                selectedSetting: '',
                onSelectSetting: (setting) {
                  if (setting == 'appearance') {
                    navContext.push(const AppSettingRoute());
                  }
                },
              ),
            ),
          ),
        ),
      (_, ProductDetailRoute(:final id), _) => KaiselStandalonePage(
          AppNavigationShell(
            currentRoute: route,
            child: ProductDetailScreen(id: id),
          ),
        ),
      _ => KaiselStandalonePage(
          AppNavigationShell(currentRoute: route, child: const HomeScreen()),
        ),
    };
  }
}

/// Two-pane layout for foldable devices / wide screens
class SettingsTwoPane extends StatelessWidget {
  const SettingsTwoPane({
    super.key,
    required this.master,
    required this.detail,
    this.hinge,
  });

  final Widget master;
  final Widget detail;
  final Rect? hinge;

  @override
  Widget build(BuildContext context) {
    final h = hinge;
    if (h == null) {
      return Row(
        children: [
          SizedBox(
            width: 320,
            child: master,
          ),
          const VerticalDivider(width: 1),
          Expanded(child: detail),
        ],
      );
    }
    return Row(
      children: [
        SizedBox(width: h.left, child: master),
        SizedBox(width: h.width),
        Expanded(child: detail),
      ],
    );
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
        backgroundColor: context.theme.colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () => context.push(const SettingsMasterRoute()),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        color: context.theme.colorScheme.primaryContainer,
        child: Center(
          child: IconButton(
            onPressed: () => context.read<AppSettingBloc>().add(
              AppSettingUpdateSeedColorEvent(Colors.purple),
            ),
            icon: const Icon(Icons.color_lens),
          ),
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
