import 'dart:ui' show DisplayFeature, DisplayFeatureType;

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/app/helpers/extensions.dart';
import 'package:blogstore/injection/dependency_injection.dart'
    show Dependencies;
import 'package:kaisel/kaisel.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/onboarding/onboarding.dart' show OnboardingScreen;
import '../../features/settings/app_setting/presentation/bloc/app_setting_bloc.dart'
    show
        AppSettingBloc,
        AppSettingUpdateSeedColorEvent,
        AppSettingTemporarilyChangeLocaleEvent;

import '../../features/settings/settings.dart';

import '../../generated/app_localizations.dart' show AppLocalizations;

part 'app_stack_codec.dart';

//  guards: [authGuard(loginBloc)],
//   reevaluateOn: loginBloc.toValueListenable(),
// KaiselGuard<AppRoute> authGuard(LoginBloc loginBloc) => (current, proposed) {
//   final isLoggedIn = loginBloc.stateValue.isLoggedIn;

//   // When unauthenticated, only LoginRoute is permitted
//   if (!isLoggedIn) {
//     if (proposed.length == 1 && proposed.first is LoginRoute) {
//       return proposed;
//     }
//     return const [LoginRoute()];
//   }

//   // When authenticated, redirect away from LoginRoute to HomeRoute
//   if (proposed.any((r) => r is LoginRoute)) {
//     return [HomeRoute(loginBloc.stateValue.username)];
//   }

//   return proposed;
// };

/// ===========================================================================
/// Application routes
/// ===========================================================================

sealed class AppRoute extends KaiselRoute {
  const AppRoute();
}

final class OnboardingRoute extends AppRoute {
  const OnboardingRoute();
}

/// ===========================================================================
/// Main shell
///
/// ├── HomeRoute
/// │   └── HomeRoot
/// │       └── ProductDetailRoute
/// │
/// └── SettingsRoute
///     └── SettingsMasterRoute
///         └── AppSettingRoute
/// ===========================================================================

sealed class MainShellRoute extends AppRoute {
  // this is our ShellHost
  const MainShellRoute();
}

/// ===========================================================================
/// Home branch
/// ===========================================================================

sealed class HomeRoute extends MainShellRoute {
  const HomeRoute();
}

/// Root of the Home navigation stack.
final class HomeRoot extends HomeRoute {
  const HomeRoot();
}

/// Detail pushed from [HomeRoot].
final class ProductDetailRoute extends HomeRoute {
  const ProductDetailRoute(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// ===========================================================================
/// Settings branch
/// ===========================================================================

sealed class SettingsRoute extends MainShellRoute {
  const SettingsRoute();
}

/// Root/master of the Settings navigation stack.
final class SettingsMasterRoute extends SettingsRoute {
  const SettingsMasterRoute();
}

final class GeneralSettingRoute extends SettingsRoute {
  const GeneralSettingRoute();
}

/// Detail pushed from [SettingsMasterRoute].
final class AppSettingRoute extends SettingsRoute {
  const AppSettingRoute();
}

final class NotificationsSettingRoute extends SettingsRoute {
  const NotificationsSettingRoute();
}

final class PrivacySettingRoute extends SettingsRoute {
  const PrivacySettingRoute();
}

/// ===========================================================================
/// Home module
/// ===========================================================================

final class HomeRouteModule extends RouteModule<HomeRoute> {
  const HomeRouteModule();

  @override
  List<HomeRoute> get initialStack => const [HomeRoot()];

  @override
  Widget buildPage(BuildContext context, HomeRoute route) {
    return switch (route) {
      HomeRoot() => const HomeScreen(),
      ProductDetailRoute(:final id) => ProductDetailScreen(id: id),
    };
  }

  @override
  ModuleStackCodec<HomeRoute>? get codec => const HomeModuleCodec();
}

final class HomeModuleCodec extends ModuleStackCodec<HomeRoute> {
  const HomeModuleCodec();

  @override
  List<String> encode(List<HomeRoute> stack) {
    return switch (stack.last) {
      HomeRoot() => const [],
      ProductDetailRoute(:final id) => ['product', id],
    };
  }

  @override
  List<HomeRoute>? decode(List<String> segments) {
    return switch (segments) {
      [] => const [HomeRoot()],
      ['product', final id] => [HomeRoot(), ProductDetailRoute(id)],
      _ => null,
    };
  }
}

/// ===========================================================================
/// Settings module
/// ===========================================================================

final class SettingsRouteModule extends RouteModule<SettingsRoute> {
  const SettingsRouteModule();

  @override
  List<SettingsRoute> get initialStack => const [SettingsMasterRoute()];

  @override
  Widget buildPage(BuildContext context, SettingsRoute route) {
    return switch (route) {
      SettingsMasterRoute() => const SettingsMasterScreen(),
      AppSettingRoute() => const AppSettingScreen(),
      GeneralSettingRoute() => const Placeholder(),
      NotificationsSettingRoute() => const Placeholder(),
      PrivacySettingRoute() => const Placeholder(),
    };
  }

  @override
  ModuleStackCodec<SettingsRoute>? get codec => const SettingsModuleCodec();
}

final class SettingsModuleCodec extends ModuleStackCodec<SettingsRoute> {
  const SettingsModuleCodec();

  @override
  List<String> encode(List<SettingsRoute> stack) {
    return switch (stack.last) {
      SettingsMasterRoute() => const [],
      AppSettingRoute() => const ['app-settings'],
      GeneralSettingRoute() => const ['general-settings'],
      NotificationsSettingRoute() => const ['notifications-settings'],
      PrivacySettingRoute() => const ['privacy-settings'],
    };
  }

  @override
  List<SettingsRoute>? decode(List<String> segments) {
    return switch (segments) {
      [] => const [SettingsMasterRoute()],
      ['app-settings'] => const [SettingsMasterRoute(), AppSettingRoute()],
      ['general-settings'] => const [
        SettingsMasterRoute(),
        GeneralSettingRoute(),
      ],
      ['notifications-settings'] => const [
        SettingsMasterRoute(),
        NotificationsSettingRoute(),
      ],
      ['privacy-settings'] => const [
        SettingsMasterRoute(),
        PrivacySettingRoute(),
      ],
      _ => null,
    };
  }
}

/// ===========================================================================
/// Adaptive helpers
/// ===========================================================================

/// Helper function to detect a vertical fold / hinge
DisplayFeature? _verticalFold(MediaQueryData mq) {
  for (final f in mq.displayFeatures) {
    final vertical =
        f.bounds.left > 0 && f.bounds.height >= mq.size.height * 0.9;
    final isFold =
        f.type == DisplayFeatureType.fold || f.type == DisplayFeatureType.hinge;
    if (vertical && isFold) return f;
  }
  return null;
}

/// ===========================================================================
/// Router
/// ===========================================================================

final class AppRouter {
  const AppRouter(this._dependencies, {this._appSettingBloc});

  final Dependencies _dependencies;
  final AppSettingBloc? _appSettingBloc;

  KaiselRouterConfig<AppRoute> get routerConfig {
    final initialRoute =
        (_appSettingBloc?.stateValue.hasCompletedOnboarding ?? false)
        ? const HomeRoot()
        : const OnboardingRoute();

    return KaiselRouterConfig<AppRoute>.adaptive(
      //don't use adaptive here we will be using that in shells
      initial: initialRoute,
      codec: AppStackCodec(_dependencies, appSettingBloc: _appSettingBloc),
      observers: () => [_dependencies.analyticsGateway.observer()],
      onScreenChanged: (route) {
        _dependencies.analyticsGateway.logScreenView(
          screenName: route.routeName,
        );
      },
      builder: _buildRoute,
    );
  }

  KaiselPageResult _buildRoute(
    BuildContext context,
    AppRoute route,
    KaiselStackContext<AppRoute> stack,
  ) {
    final mediaQuery = MediaQuery.of(context);
    final fold = _verticalFold(mediaQuery);

    final isWide = fold != null || mediaQuery.size.width >= 700;

    return switch ((stack.previous, route, isWide)) {
      // ---------------------------------------------------------------------
      // Onboarding
      // ---------------------------------------------------------------------

      (_, OnboardingRoute(), _) => const KaiselStandalonePage(
        OnboardingScreen(), // will make it responsive in future  may be different for a larger display
      ),

      (_, MainShellRoute(), _) => KaiselStandalonePage(_LazyShell()),
    };
  }
}

/// ===========================================================================
/// Settings adaptive layout
/// ===========================================================================

final class SettingsTwoPane extends StatelessWidget {
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: 320, child: master),
          const VerticalDivider(width: 1),
          Expanded(child: detail),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(width: h.left, child: master),
        SizedBox(width: h.width),
        Expanded(child: detail),
      ],
    );
  }
}

/// ===========================================================================
/// Screens
/// ===========================================================================

final class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: context.theme.colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              context.push(const SettingsMasterRoute());
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        color: context.theme.colorScheme.primaryContainer,
        alignment: Alignment.center,
        child: IconButton(
          onPressed: () {
            context.read<AppSettingBloc>().add(
              AppSettingUpdateSeedColorEvent(Colors.purple),
            );
          },
          icon: const Icon(Icons.color_lens),
        ),
      ),
    );
  }
}

final class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Placeholder(key: ValueKey(id));
  }
}

class AppNavItem {
  final String label;
  final IconData unselectedIcon;
  final IconData selectedIcon;

  const AppNavItem({
    required this.label,
    required this.unselectedIcon,
    required this.selectedIcon,
  });
}

class _LazyShell extends StatelessWidget {
  // add some constructor stuffs
  const _LazyShell();

  // Single source of truth for all navigation destinations
  static final List<AppNavItem> _navItems = [
    AppNavItem(
      label: 'Home',
      unselectedIcon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    AppNavItem(
      label: 'Store',
      unselectedIcon: Icons.storefront_outlined,
      selectedIcon: Icons.storefront,
    ),
    AppNavItem(
      label: 'Drafts',
      unselectedIcon: Icons.edit_note_outlined,
      selectedIcon: Icons.edit_note,
    ),
    AppNavItem(
      label: 'Settings',
      unselectedIcon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
    ),
  ];

  KaiselPageResult _buildContentRoute(
    BuildContext context,
    SettingsRoute route,
    KaiselStackContext<SettingsRoute> ctx,
  ) {
    final mq = MediaQuery.of(context);
    final fold = _verticalFold(mq);
    final isWide = fold != null || mq.size.width >= 700;

    if (isWide) {
      final twoPaneWidget = SettingsTwoPane(
        master: SettingsMasterScreen(
          selectedRoute: route,
          onSelectRoute: (tileContext, targetRoute) {
            tileContext.push(targetRoute);
          },
        ),
        detail: switch (route) {
          AppSettingRoute() => const AppSettingScreen(),
          GeneralSettingRoute() => const Placeholder(),
          NotificationsSettingRoute() => const Placeholder(),
          PrivacySettingRoute() => const Placeholder(),
          _ => const AppSettingScreen(),
        },
        hinge: fold?.bounds,
      );

      return (ctx.previous is SettingsMasterRoute)
          ? KaiselAbsorbingPage(widget: twoPaneWidget)
          : KaiselStandalonePage(twoPaneWidget);
    }
    return KaiselStandalonePage(switch (route) {
      AppSettingRoute() => const AppSettingScreen(),
      GeneralSettingRoute() => const Placeholder(),
      NotificationsSettingRoute() => const Placeholder(),
      PrivacySettingRoute() => const Placeholder(),
      _ => SettingsMasterScreen(
        selectedRoute: route,
        onSelectRoute: (tileContext, targetRoute) {
          tileContext.push(targetRoute);
        },
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final fold = _verticalFold(mediaQuery);

    final isWide = fold != null || mediaQuery.size.width >= 700;

    return KaiselBranchedShell.specs(
      lazy: true,
      branches: [
        KaiselBranchSpec<HomeRoute>.adaptive(
          initial: const HomeRoot(),
          builder: (context, route, stack) {
            return switch (route) {
              HomeRoot() => const KaiselStandalonePage(HomeScreen()),

              ProductDetailRoute(:final id) => KaiselStandalonePage(
                ProductDetailScreen(id: id),
              ),
            };
          },
        ),
        KaiselBranchSpec<SettingsRoute>.adaptive(
          initial: const SettingsMasterRoute(),
          builder: _buildContentRoute,
        ),
      ],
      chromeBuilder: (context, active, content, switchBranch) => (isWide)
          ? Scaffold(
              body: Row(
                children: [
                  NavigationRail(
                    selectedIndex: active,
                    onDestinationSelected: switchBranch,
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: context.theme.colorScheme.surfaceContainer,
                    // Top header icon
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 24),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor:
                            context.theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.settings,
                          color: context.theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    destinations: _navItems.map((item) {
                      return NavigationRailDestination(
                        icon: Icon(item.unselectedIcon),
                        selectedIcon: Icon(item.selectedIcon),
                        label: Text(item.label),
                      );
                    }).toList(),
                  ),
                  const VerticalDivider(width: 1, thickness: 1),
                  Expanded(child: content),
                ],
              ),
            )
          : Scaffold(
              body: content,
              bottomNavigationBar: NavigationBar(
                selectedIndex: active,
                onDestinationSelected: switchBranch,
                destinations: _navItems.map((item) {
                  return NavigationDestination(
                    icon: Icon(item.unselectedIcon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: item.label,
                  );
                }).toList(),
              ),
            ),
    );
  }
}
