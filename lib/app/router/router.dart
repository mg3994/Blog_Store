import 'dart:ui' show DisplayFeature, DisplayFeatureType;
import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/app/helpers/extensions.dart';
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

final class GeneralSettingRoute extends AppRoute {
  const GeneralSettingRoute();
}

final class AppSettingRoute extends AppRoute {
  const AppSettingRoute();
}

final class NotificationSettingRoute extends AppRoute {
  const NotificationSettingRoute();
}

final class PrivacySettingRoute extends AppRoute {
  const PrivacySettingRoute();
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

  // Helper to map setting string to actual route
  AppRoute _getRouteForSetting(String settingId) {
    return switch (settingId) {
      'general' => const GeneralSettingRoute(),
      'appearance' => const AppSettingRoute(),
      'notifications' => const NotificationSettingRoute(),
      'privacy' => const PrivacySettingRoute(),
      _ => const AppSettingRoute(),
    };
  }

  Widget _getDetailWidgetForRoute(AppRoute route) {
    return switch (route) {
      GeneralSettingRoute() => const GeneralSettingScreen(),
      NotificationSettingRoute() => const NotificationSettingScreen(),
      PrivacySettingRoute() => const PrivacySettingScreen(),
      _ => const AppSettingScreen(),
    };
  }

  String _getSettingIdForRoute(AppRoute route) {
    return switch (route) {
      GeneralSettingRoute() => 'general',
      NotificationSettingRoute() => 'notifications',
      PrivacySettingRoute() => 'privacy',
      _ => 'appearance',
    };
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
      // Wide / Foldable screens (Master -> Detail absorption for all settings routes)
      (
        SettingsMasterRoute(),
        GeneralSettingRoute() |
            AppSettingRoute() |
            NotificationSettingRoute() |
            PrivacySettingRoute(),
        true
      ) =>
        KaiselAbsorbingPage(
          widget: AppNavigationShell(
            currentRoute: route,
            child: SettingsTwoPane(
              master: SettingsMasterScreen(
                selectedSetting: _getSettingIdForRoute(route),
                onSelectSetting: (tileContext, setting) {
                  tileContext.pushOrReplaceTop(_getRouteForSetting(setting));
                },
              ),
              detail: _getDetailWidgetForRoute(route),
              hinge: fold?.bounds,
            ),
          ),
        ),
      (
        _,
        GeneralSettingRoute() |
            AppSettingRoute() |
            NotificationSettingRoute() |
            PrivacySettingRoute(),
        true
      ) =>
        KaiselStandalonePage(
          AppNavigationShell(
            currentRoute: route,
            child: SettingsTwoPane(
              master: SettingsMasterScreen(
                selectedSetting: _getSettingIdForRoute(route),
                onSelectSetting: (tileContext, setting) {
                  tileContext.pushOrReplaceTop(_getRouteForSetting(setting));
                },
              ),
              detail: _getDetailWidgetForRoute(route),
              hinge: fold?.bounds,
            ),
          ),
        ),
      (_, SettingsMasterRoute(), true) => KaiselStandalonePage(
          AppNavigationShell(
            currentRoute: route,
            child: SettingsTwoPane(
              master: SettingsMasterScreen(
                selectedSetting: 'appearance',
                onSelectSetting: (tileContext, setting) {
                  tileContext.pushOrReplaceTop(_getRouteForSetting(setting));
                },
              ),
              detail: const AppSettingScreen(),
              hinge: fold?.bounds,
            ),
          ),
        ),

      // Single pane compact screens: Standalone page push/pop
      (_, GeneralSettingRoute(), false) => KaiselStandalonePage(
          AppNavigationShell(
            currentRoute: route,
            child: const GeneralSettingScreen(),
          ),
        ),
      (_, AppSettingRoute(), false) => KaiselStandalonePage(
          AppNavigationShell(
            currentRoute: route,
            child: const AppSettingScreen(),
          ),
        ),
      (_, NotificationSettingRoute(), false) => KaiselStandalonePage(
          AppNavigationShell(
            currentRoute: route,
            child: const NotificationSettingScreen(),
          ),
        ),
      (_, PrivacySettingRoute(), false) => KaiselStandalonePage(
          AppNavigationShell(
            currentRoute: route,
            child: const PrivacySettingScreen(),
          ),
        ),
      (_, SettingsMasterRoute(), false) => KaiselStandalonePage(
          AppNavigationShell(
            currentRoute: route,
            child: SettingsMasterScreen(
              selectedSetting: '',
              onSelectSetting: (tileContext, setting) {
                tileContext.push(_getRouteForSetting(setting));
              },
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
    final mq = MediaQuery.of(context);
    final railOffset = mq.size.width >= 700 ? 88.0 : 0.0;

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

    final masterWidth = (h.left - railOffset).clamp(0.0, double.infinity);

    return Row(
      children: [
        SizedBox(width: masterWidth, child: master),
        SizedBox(width: h.width),
        Expanded(child: detail),
      ],
    );
  }
}

// AppNavigationShell providing responsive navigation chrome
class AppNavigationShell extends StatelessWidget {
  const AppNavigationShell({
    super.key,
    required this.currentRoute,
    required this.child,
  });

  final AppRoute currentRoute;
  final Widget child;

  int _calculateSelectedIndex() {
    return switch (currentRoute) {
      HomeRoute() => 0,
      SettingsMasterRoute() ||
      GeneralSettingRoute() ||
      AppSettingRoute() ||
      NotificationSettingRoute() ||
      PrivacySettingRoute() =>
        3,
      _ => 0,
    };
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.pushOrReplaceTop(const HomeRoute());
        break;
      case 1:
        // Store
        break;
      case 2:
        // Drafts / Notifications
        break;
      case 3:
        context.pushOrReplaceTop(const SettingsMasterRoute());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isWide = mq.size.width >= 700;
    final theme = Theme.of(context);
    final selectedIndex = _calculateSelectedIndex();

    if (isWide) {
      final railItems = <Map<String, dynamic>>[
        {
          'label': 'Home',
          'selectedIcon': Icons.home,
          'unselectedIcon': Icons.home_outlined,
          'index': 0,
        },
        {
          'label': 'Store',
          'selectedIcon': Icons.storefront,
          'unselectedIcon': Icons.storefront_outlined,
          'index': 1,
        },
        {
          'label': 'Drafts',
          'selectedIcon': Icons.edit_note,
          'unselectedIcon': Icons.edit_note_outlined,
          'index': 2,
        },
        {
          'label': 'Settings',
          'selectedIcon': Icons.settings,
          'unselectedIcon': Icons.settings_outlined,
          'index': 3,
        },
      ];

      return Scaffold(
        body: Row(
          children: [
            Container(
              width: 88,
              color: theme.colorScheme.surfaceContainer,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.settings,
                        color: theme.colorScheme.onPrimaryContainer,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 36),
                    ...railItems.map((item) {
                      final int index = item['index'] as int;
                      final bool isSelected = selectedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: InkWell(
                          onTap: () => _onItemTapped(context, index),
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 64,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primaryContainer
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSelected
                                      ? item['selectedIcon'] as IconData
                                      : item['unselectedIcon'] as IconData,
                                  color: isSelected
                                      ? theme.colorScheme.onPrimaryContainer
                                      : theme.colorScheme.onSurfaceVariant,
                                  size: 24,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item['label'] as String,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: isSelected
                                        ? theme.colorScheme.onPrimaryContainer
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Store',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note),
            label: 'Drafts',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// 4. Decoupled Screen Views
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
