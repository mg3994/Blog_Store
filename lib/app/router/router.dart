import 'dart:ui' show DisplayFeature, DisplayFeatureType;
import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/app/helpers/extensions.dart';
import 'package:blogstore/injection/dependency_injection.dart' show Dependencies;
import 'package:kaisel/kaisel.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/settings/settings.dart';
import '../../features/settings/app_setting/presentation/bloc/app_setting_bloc.dart'
    show AppSettingBloc, AppSettingUpdateSeedColorEvent;

// ==========================================
// 1. ROUTE DEFINITIONS
// ==========================================

sealed class AppRoute extends KaiselRoute {
  const AppRoute();
}

final class ShellHostRoute extends AppRoute {
  const ShellHostRoute();
}

sealed class HomeRoute extends KaiselRoute {
  const HomeRoute();
}

final class HomeRootRoute extends HomeRoute {
  const HomeRootRoute();
}

final class ProductDetailRoute extends HomeRoute {
  final String id;
  const ProductDetailRoute(this.id);
}

sealed class SettingsRoute extends KaiselRoute {
  const SettingsRoute();
}

final class SettingsMasterRoute extends SettingsRoute {
  const SettingsMasterRoute();
}

final class GeneralSettingRoute extends SettingsRoute {
  const GeneralSettingRoute();
}

final class AppSettingRoute extends SettingsRoute {
  const AppSettingRoute();
}

final class NotificationSettingRoute extends SettingsRoute {
  const NotificationSettingRoute();
}

final class PrivacySettingRoute extends SettingsRoute {
  const PrivacySettingRoute();
}

// ==========================================
// 2. FOLDABLE / HINGE UTILITIES & TWO-PANE WIDGET
// ==========================================

DisplayFeature? _verticalFold(MediaQueryData mq) {
  for (final f in mq.displayFeatures) {
    final vertical = f.bounds.left > 0 && f.bounds.height >= mq.size.height * 0.9;
    final isFold = f.type == DisplayFeatureType.fold || f.type == DisplayFeatureType.hinge;
    if (vertical && isFold) return f;
  }
  return null;
}

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
          SizedBox(width: 320, child: master),
          const VerticalDivider(width: 1, thickness: 1),
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

// ==========================================
// 3. ADAPTIVE BUILDER FOR SETTINGS
// ==========================================

SettingsRoute _getRouteForSetting(String settingId) {
  return switch (settingId) {
    'general' => const GeneralSettingRoute(),
    'appearance' => const AppSettingRoute(),
    'notifications' => const NotificationSettingRoute(),
    'privacy' => const PrivacySettingRoute(),
    _ => const AppSettingRoute(),
  };
}

Widget _getDetailWidgetForRoute(SettingsRoute route) {
  return switch (route) {
    GeneralSettingRoute() => const GeneralSettingScreen(),
    NotificationSettingRoute() => const NotificationSettingScreen(),
    PrivacySettingRoute() => const PrivacySettingScreen(),
    _ => const AppSettingScreen(),
  };
}

String? _getSettingIdForRoute(SettingsRoute route) {
  return switch (route) {
    GeneralSettingRoute() => 'general',
    AppSettingRoute() => 'appearance',
    NotificationSettingRoute() => 'notifications',
    PrivacySettingRoute() => 'privacy',
    _ => null,
  };
}

KaiselPageResult _settingsAdaptiveBuilder(
  BuildContext context,
  SettingsRoute route,
  KaiselStackContext<SettingsRoute> ctx,
) {
  final mq = MediaQuery.of(context);
  final fold = _verticalFold(mq);
  final isSpanned = fold != null || mq.size.width >= 700;
  final selectedId = _getSettingIdForRoute(route);

  return switch ((ctx.previous, route, isSpanned)) {
    // 1. WIDE/FOLDABLE: Detail pushed on top of Master -> Absorb master into side-by-side frame
    (
      SettingsMasterRoute(),
      GeneralSettingRoute() |
          AppSettingRoute() |
          NotificationSettingRoute() |
          PrivacySettingRoute(),
      true
    ) =>
      KaiselAbsorbingPage(
        widget: SettingsTwoPane(
          master: SettingsMasterScreen(
            selectedSetting: selectedId ?? 'appearance',
            onSelectSetting: (tileContext, setting) {
              tileContext
                  .router<SettingsRoute>()
                  .pushOrReplaceTop(_getRouteForSetting(setting));
            },
          ),
          detail: _getDetailWidgetForRoute(route),
          hinge: fold?.bounds,
        ),
        absorbing: 1,
      ),

    // 2. WIDE/FOLDABLE: Master view on wide screen with default detail pane
    (_, SettingsMasterRoute(), true) => KaiselStandalonePage(
        SettingsTwoPane(
          master: SettingsMasterScreen(
            selectedSetting: 'appearance',
            onSelectSetting: (tileContext, setting) {
              tileContext
                  .router<SettingsRoute>()
                  .pushOrReplaceTop(_getRouteForSetting(setting));
            },
          ),
          detail: const AppSettingScreen(),
          hinge: fold?.bounds,
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
        SettingsTwoPane(
          master: SettingsMasterScreen(
            selectedSetting: selectedId ?? 'appearance',
            onSelectSetting: (tileContext, setting) {
              tileContext
                  .router<SettingsRoute>()
                  .pushOrReplaceTop(_getRouteForSetting(setting));
            },
          ),
          detail: _getDetailWidgetForRoute(route),
          hinge: fold?.bounds,
        ),
      ),

    // 3. NARROW (Mobile): Standalone Detail Screens
    (_, GeneralSettingRoute(), false) => const KaiselStandalonePage(GeneralSettingScreen()),
    (_, AppSettingRoute(), false) => const KaiselStandalonePage(AppSettingScreen()),
    (_, NotificationSettingRoute(), false) => const KaiselStandalonePage(NotificationSettingScreen()),
    (_, PrivacySettingRoute(), false) => const KaiselStandalonePage(PrivacySettingScreen()),

    // 4. NARROW (Mobile): Standalone Master Screen
    (_, SettingsMasterRoute(), false) => KaiselStandalonePage(
        SettingsMasterScreen(
          selectedSetting: '',
          onSelectSetting: (tileContext, setting) {
            tileContext
                .router<SettingsRoute>()
                .push(_getRouteForSetting(setting));
          },
        ),
      ),
  };
}

// ==========================================
// 4. APP NAVIGATION SHELL (HOST & CHROME BUILDER)
// ==========================================

class AppNavigationShell extends StatefulWidget {
  const AppNavigationShell({super.key});

  @override
  State<AppNavigationShell> createState() => _AppNavigationShellState();
}

class _AppNavigationShellState extends State<AppNavigationShell> {
  late final KaiselRouter<HomeRoute> _homeRouter =
      KaiselRouter(initial: const HomeRootRoute());
  late final KaiselRouter<SettingsRoute> _settingsRouter =
      KaiselRouter(initial: const SettingsMasterRoute());

  late final BranchedShellRouter _shell = BranchedShellRouter(
    branches: [_homeRouter, _settingsRouter],
  );

  @override
  void dispose() {
    _shell.dispose();
    _homeRouter.dispose();
    _settingsRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KaiselBranchedShell(
      shell: _shell,
      branches: [
        KaiselBranch<HomeRoute>(
          router: _homeRouter,
          pageBuilder: (context, route) => switch (route) {
            HomeRootRoute() => const KaiselStandalonePage(HomeScreen()),
            ProductDetailRoute(:final id) =>
              KaiselStandalonePage(ProductDetailScreen(id: id)),
          },
        ),
        KaiselBranch<SettingsRoute>.adaptive(
          router: _settingsRouter,
          pageBuilder: _settingsAdaptiveBuilder,
        ),
      ],
      chromeBuilder: (context, activeBranch, branchContent, switchBranch) {
        final mq = MediaQuery.of(context);
        final isWide = mq.size.width >= 700 || _verticalFold(mq) != null;
        final theme = Theme.of(context);

        if (isWide) {
          final railItems = <Map<String, dynamic>>[
            {
              'label': 'Home',
              'selectedIcon': Icons.home,
              'unselectedIcon': Icons.home_outlined,
              'index': 0,
            },
            {
              'label': 'Settings',
              'selectedIcon': Icons.settings,
              'unselectedIcon': Icons.settings_outlined,
              'index': 1,
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
                          final bool isSelected = activeBranch == index;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: InkWell(
                              onTap: () => switchBranch(index),
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
                Expanded(child: branchContent),
              ],
            ),
          );
        }

        return Scaffold(
          body: branchContent,
          bottomNavigationBar: NavigationBar(
            selectedIndex: activeBranch,
            onDestinationSelected: switchBranch,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}

// ==========================================
// 5. ROUTER CONFIGURATION CLASS
// ==========================================

final class AppRouter {
  const AppRouter(this._dependencies);

  final Dependencies _dependencies;

  KaiselRouterConfig<AppRoute> createConfig() {
    return KaiselRouterConfig<AppRoute>(
      initial: const ShellHostRoute(),
      observers: () => [_dependencies.analyticsGateway.observer()],
      onScreenChanged: (route) =>
          _dependencies.analyticsGateway.logScreenView(route.routeName),
      builder: (context, route) => switch (route) {
        ShellHostRoute() => const KaiselStandalonePage(AppNavigationShell()),
      },
    );
  }
}

// ==========================================
// 6. SCREEN VIEWS
// ==========================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: context.theme.colorScheme.primary,
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
