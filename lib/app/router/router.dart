import 'dart:ui' show DisplayFeature, DisplayFeatureType;

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:blogstore/app/helpers/extensions.dart';
import 'package:blogstore/app/widgets/app_navigation_shell.dart';
import 'package:blogstore/injection/dependency_injection.dart'
    show Dependencies;
import 'package:kaisel/kaisel.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/consent/presentation/widgets/analytics_consent_modal.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/settings/app_setting/presentation/bloc/app_setting_bloc.dart'
    show
        AppSettingBloc,
        AppSettingUpdateSeedColorEvent,
        AppSettingTemporarilyChangeLocaleEvent;
import '../../features/settings/presentation/screens/privacy_setting_screen.dart';
import '../../features/settings/settings.dart';
import '../../generated/app_localizations.dart' show AppLocalizations;

part 'app_stack_codec.dart';

// 1. Sealed Route Hierarchy
sealed class AppRoute extends KaiselRoute {
  const AppRoute();
}

final class OnboardingRoute extends AppRoute {
  const OnboardingRoute();
}

final class SettingsMasterRoute extends AppRoute {
  const SettingsMasterRoute();
}

final class AppSettingRoute extends AppRoute {
  const AppSettingRoute();
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
    final vertical =
        f.bounds.left > 0 && f.bounds.height >= mq.size.height * 0.9;
    final isFold =
        f.type == DisplayFeatureType.fold || f.type == DisplayFeatureType.hinge;
    if (vertical && isFold) return f;
  }
  return null;
}

// 2. Class-Based Router accepting Dependencies
final class AppRouter {
  const AppRouter(this._dependencies, {AppSettingBloc? appSettingBloc})
      : _appSettingBloc = appSettingBloc;

  final Dependencies _dependencies;
  final AppSettingBloc? _appSettingBloc;

  KaiselRouteInformationParser<AppRoute> get routeInformationParser =>
      KaiselRouteInformationParser<AppRoute>.fromStackCodec(
        codec: AppStackCodec(_dependencies, appSettingBloc: _appSettingBloc),
        fallback: const [HomeRoute()],
      );

  KaiselRouterConfig<AppRoute> get routerConfig {
    final initialRoute =
        (_appSettingBloc?.stateValue.hasCompletedOnboarding ?? false)
            ? const HomeRoute()
            : const OnboardingRoute();

    return KaiselRouterConfig<AppRoute>.adaptive(
      initial: initialRoute,
      observers: () => [_dependencies.analyticsGateway.observer()],
      onScreenChanged: (route) => _dependencies.analyticsGateway.logScreenView(
        screenName: route.routeName,
      ),
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
      (_, OnboardingRoute(), _) => const KaiselStandalonePage(
        OnboardingScreen(),
      ),

      // Wide / Foldable screens (Master -> Detail)
      (SettingsMasterRoute(), AppSettingRoute(), true) => KaiselAbsorbingPage(
        widget: AppNavigationShell(
          currentRoute: route,
          child: SettingsTwoPane(
            master: SettingsMasterScreen(
              selectedSetting: 'appearance',
              onSelectSetting: (tileContext, setting) {
                if (setting == 'appearance') {
                  tileContext.pushOrReplaceTop(const AppSettingRoute());
                } else if (setting == 'privacy') {
                  tileContext.pushOrReplaceTop(const PrivacySettingRoute());
                }
              },
            ),
            detail: const AppSettingScreen(),
            hinge: fold?.bounds,
          ),
        ),
      ),
      (SettingsMasterRoute(), PrivacySettingRoute(), true) =>
        KaiselAbsorbingPage(
          widget: AppNavigationShell(
            currentRoute: route,
            child: SettingsTwoPane(
              master: SettingsMasterScreen(
                selectedSetting: 'privacy',
                onSelectSetting: (tileContext, setting) {
                  if (setting == 'appearance') {
                    tileContext.pushOrReplaceTop(const AppSettingRoute());
                  } else if (setting == 'privacy') {
                    tileContext.pushOrReplaceTop(const PrivacySettingRoute());
                  }
                },
              ),
              detail: const PrivacySettingScreen(),
              hinge: fold?.bounds,
            ),
          ),
        ),
      (_, AppSettingRoute(), true) => KaiselStandalonePage(
        AppNavigationShell(
          currentRoute: route,
          child: SettingsTwoPane(
            master: SettingsMasterScreen(
              selectedSetting: 'appearance',
              onSelectSetting: (tileContext, setting) {
                if (setting == 'appearance') {
                  tileContext.pushOrReplaceTop(const AppSettingRoute());
                } else if (setting == 'privacy') {
                  tileContext.pushOrReplaceTop(const PrivacySettingRoute());
                }
              },
            ),
            detail: const AppSettingScreen(),
            hinge: fold?.bounds,
          ),
        ),
      ),
      (_, PrivacySettingRoute(), true) => KaiselStandalonePage(
        AppNavigationShell(
          currentRoute: route,
          child: SettingsTwoPane(
            master: SettingsMasterScreen(
              selectedSetting: 'privacy',
              onSelectSetting: (tileContext, setting) {
                if (setting == 'appearance') {
                  tileContext.pushOrReplaceTop(const AppSettingRoute());
                } else if (setting == 'privacy') {
                  tileContext.pushOrReplaceTop(const PrivacySettingRoute());
                }
              },
            ),
            detail: const PrivacySettingScreen(),
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
                if (setting == 'appearance') {
                  tileContext.pushOrReplaceTop(const AppSettingRoute());
                } else if (setting == 'privacy') {
                  tileContext.pushOrReplaceTop(const PrivacySettingRoute());
                }
              },
            ),
            detail: const AppSettingScreen(),
            hinge: fold?.bounds,
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
              if (setting == 'appearance') {
                tileContext.push(const AppSettingRoute());
              } else if (setting == 'privacy') {
                tileContext.push(const PrivacySettingRoute());
              }
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
    if (h == null) {
      return Row(
        children: [
          SizedBox(width: 320, child: master),
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
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AnalyticsConsentModal.showIfNeeded(context);
      }
    });
  }

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

// // The main stack hosts the shell as a single route, wired through
// // KaiselRouterConfig like the other examples.
// sealed class AppRoute extends KaiselRoute {
//   const AppRoute();
// }

// final class ShellHostRoute extends AppRoute {
//   const ShellHostRoute();
// }

// sealed class HomeRoute extends KaiselRoute {
//   const HomeRoute();
// }

// final class HomeRoot extends HomeRoute {
//   const HomeRoot();
// }

// sealed class SettingsRoute extends KaiselRoute {
//   const SettingsRoute();
// }

// sealed class SettingsMasterRoute extends SettingsRoute {
//   const SettingsMasterRoute();
// }

// final class AppSettingRoute extends SettingsMasterRoute {
//   const AppSettingRoute();
// }

// final class AppRouter {
//   const AppRouter(this._dependencies);

//   final Dependencies _dependencies;

//   KaiselRouterConfig<AppRoute> createConfig() {}
// }

///////////////////
// DevTools inspector playground.
//
// One app that exercises every feature the kaisel DevTools extension
// surfaces, so you can watch each panel update live. Run:
//
//   flutter run -t lib/main_inspector.dart
//
// then open DevTools → the "kaisel" tab and drive it from the Hub screen.
// Use a WIDE window (desktop / iPad / Chrome) so the Inbox shows its
// adaptive master-detail layout.
//
// What it exercises
// -----------------
//  - Main stack            — every Hub button pushes/pops the main router.
//  - Branched shell         — "Open shell" mounts a 2-branch shell (Feed +
//                             Inbox). Inbox is adaptive master-detail.
//  - Modules                — "Open checkout" mounts a module with its own
//                             URL codec.
//  - Modal flows (nested)   — "Run confirm flow" opens a flow; from inside it
//                             you can open a second, nested flow.
//  - Guard trace            — "Go to Locked" is rewritten by a guard; the
//                             Guards panel shows the redirect.
//  - Codec / URL            — every state encodes to a URL (URL panel).
//  - No-op / missing props  — the Inbox tab has TWO kinds of message detail:
//                             a Correct one (overrides `props`) and a Buggy
//                             one (missing `props`). In master-detail, open a
//                             *Buggy* message, then tap another Buggy message:
//                             the detail does NOT change (pushOrReplaceTop is a
//                             no-op because the routes are value-equal). The
//                             inspector shows an empty diff — exactly the bug.
//                             The Correct rows switch fine, for contrast.

// import 'dart:ui' show DisplayFeature, DisplayFeatureType;

// import 'package:flutter/material.dart';
// import 'package:kaisel/kaisel.dart';

// import '../../injection/dependency_injection.dart' show Dependencies;
// import 'lazy_reports.dart' deferred as reports;

// const _wide = 700.0;

// // final _config = KaiselRouterConfig<AppRoute>(
// //   initial: const Hub(),
// //   guards: [_passthroughGuard, _lockGuard],
// //   builder: _buildMain,
// //   modalBuilder: _buildModal,
// //   codec: _appCodec,
// //   fallback: const [Hub()],
// // );

// final class AppRouter {
//   const AppRouter(this._dependencies);

//   final Dependencies _dependencies;

//   KaiselRouterConfig createConfig() => _config;
// }

// sealed class AppRoute extends KaiselRoute {
//   const AppRoute();
// }

// final class LoginRoute extends AppRoute {
//   const LoginRoute();
// }

// /// Wraps the entire post-login experience: sidebar + breadcrumb +
// /// branched content. The shell's branches and per-branch stacks live
// /// inside the widget, not on the main router's stack.
// final class ShellHost extends AppRoute {
//   const ShellHost();
// }

// // Per-branch routes

// sealed class HomeRoute extends KaiselRoute {
//   const HomeRoute();
// }

// final class HomeView extends HomeRoute {
//   const HomeView();
// }

// sealed class LibraryRoute extends KaiselRoute {
//   const LibraryRoute();
// }

// final class LibraryView extends LibraryRoute {
//   const LibraryView();
// }

// /// Test branch demonstrates a deeper nested stack.
// sealed class TestRoute extends KaiselRoute {
//   const TestRoute();
// }

// final class TestHome extends TestRoute {
//   const TestHome();
// }

// final class CollectionView extends TestRoute {
//   const CollectionView(this.id);
//   final String id;
//   @override
//   List<Object?> get props => [id];
// }

// final class VideoPlayerView extends TestRoute {
//   const VideoPlayerView({required this.collectionId, required this.fileName});
//   final String collectionId;
//   final String fileName;
//   @override
//   List<Object?> get props => [collectionId, fileName];
// }

// // A stable demo UUID used so the breadcrumb matches across runs.
// const _demoCollectionId = '019e88b7-5075-734b-b454-07e4fa729888';

// // Demo media catalog. Mock content so the master-detail layout has
// // something to chew on at wide widths.
// const _demoMedia = <String>[
//   'intro.mp4',
//   'lesson_01_routes_as_values.mp4',
//   'lesson_02_codec_as_bridge.mp4',
//   'lesson_03_adaptive_layouts.mp4',
//   'outro.mp4',
// ];

// // Wide breakpoint for the master-detail layout in the test branch.
// // At or above this content width, CollectionView + VideoPlayerView
// // absorb into one rendered page laid out side-by-side. Below, the
// // video player slides on top of the collection list.
// const _wideBreakpoint = 700.0;

// // Top-level fade transition
// //
// // Login and the logged-in shell are siblings on the main router's
// // stack but they feel like different surfaces. Slide-on-push would
// // look wrong here; we want a cross-fade so the auth state change
// // reads as a state transition rather than a navigation event.

// class _FadePage<T> extends Page<T> {
//   const _FadePage({required LocalKey super.key, required this.child});
//   final Widget child;

//   @override
//   Route<T> createRoute(BuildContext context) {
//     return PageRouteBuilder<T>(
//       settings: this,
//       pageBuilder: (_, _, _) => child,
//       transitionDuration: const Duration(milliseconds: 320),
//       reverseTransitionDuration: const Duration(milliseconds: 320),
//       transitionsBuilder: (_, anim, _, child) =>
//           FadeTransition(opacity: anim, child: child),
//     );
//   }
// }

// Page<Object?> _appPageWrapper(KaiselPageWrapperContext<AppRoute> ctx) {
//   // LoginRoute and ShellHost are full-surface auth states swapped with
//   // `router.set(...)`, which collapses the main stack to a single entry — so
//   // `ctx.previous` is null and we can't pattern-match on the route pair.
//   // Fade whenever one of these surfaces appears so the swap cross-fades
//   // instead of sliding. (The very first mount fades the login screen in once.)
//   if (ctx.route is LoginRoute || ctx.route is ShellHost) {
//     return _FadePage<Object?>(key: ctx.key, child: ctx.child);
//   }
//   return MaterialPage<Object?>(key: ctx.key, child: ctx.child);
// }

// // Screens

// /// Full-screen login. No shell chrome; this lives at the top-level
// /// router and replaces the entire surface.
// class _LoginScreen extends StatelessWidget {
//   const _LoginScreen();

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: const Color(0xFFA8D5D8),
//       child: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'LoginView',
//               style: TextStyle(color: Colors.black87, fontSize: 18),
//             ),
//             const SizedBox(height: 8),
//             TextButton(
//               onPressed: () {
//                 // The auth state is the stack. Replace LoginRoute with
//                 // ShellHost; the page wrapper cross-fades the swap.
//                 context.set(const [ShellHost()]);
//               },
//               child: const Text(
//                 'Go to Content View',
//                 style: TextStyle(color: Colors.black87),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _HomeScreen extends StatelessWidget {
//   const _HomeScreen();

//   @override
//   Widget build(BuildContext context) {
//     return const Material(
//       color: Colors.white,
//       child: Center(
//         child: Text(
//           'Home View',
//           style: TextStyle(color: Colors.black87, fontSize: 16),
//         ),
//       ),
//     );
//   }
// }

// class _LibraryScreen extends StatelessWidget {
//   const _LibraryScreen();

//   @override
//   Widget build(BuildContext context) {
//     return const Material(
//       color: Colors.white,
//       child: Center(
//         child: Text(
//           'Library View',
//           style: TextStyle(color: Colors.black87, fontSize: 16),
//         ),
//       ),
//     );
//   }
// }

// class _TestHomeScreen extends StatelessWidget {
//   const _TestHomeScreen();

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white,
//       child: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Test Home',
//               style: TextStyle(color: Colors.black87, fontSize: 16),
//             ),
//             const SizedBox(height: 12),
//             TextButton(
//               onPressed: () {
//                 context.push(const CollectionView(_demoCollectionId));
//               },
//               child: const Text(
//                 'Open demo collection',
//                 style: TextStyle(color: Colors.black87),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Collection view doubles as master pane and standalone screen.
// /// When rendered as the master pane inside an absorbed page,
// /// [selectedFileName] is set and the matching item is highlighted.
// /// When rendered standalone (narrow widths, or no detail pushed yet),
// /// it's null.
// class _CollectionScreen extends StatelessWidget {
//   const _CollectionScreen({required this.id, this.selectedFileName});
//   final String id;
//   final String? selectedFileName;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: const Color(0xFFB2D4D4),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//             child: Text(
//               'Collection View - id: $id',
//               style: const TextStyle(color: Colors.black87, fontSize: 13),
//             ),
//           ),
//           const Divider(height: 1, color: Colors.black26),
//           Expanded(
//             child: ListView.separated(
//               padding: EdgeInsets.zero,
//               itemCount: _demoMedia.length,
//               separatorBuilder: (_, _) =>
//                   const Divider(height: 1, color: Colors.black12),
//               itemBuilder: (context, i) {
//                 final fileName = _demoMedia[i];
//                 final selected = fileName == selectedFileName;
//                 return ListTile(
//                   dense: true,
//                   selected: selected,
//                   selectedTileColor: Colors.black.withValues(alpha: 0.06),
//                   leading: Icon(
//                     Icons.play_circle_outline,
//                     color: selected ? const Color(0xFF8E2C3A) : Colors.black54,
//                   ),
//                   title: Text(
//                     fileName,
//                     style: TextStyle(
//                       color: Colors.black87,
//                       fontWeight: selected
//                           ? FontWeight.w600
//                           : FontWeight.normal,
//                     ),
//                   ),
//                   trailing: selected
//                       ? const Icon(
//                           Icons.chevron_right,
//                           color: Color(0xFF8E2C3A),
//                         )
//                       : const Icon(Icons.chevron_right, color: Colors.black38),
//                   onTap: () {
//                     // pushOrReplaceTop is the right call inside an
//                     // adaptive master-detail: push the detail when
//                     // the current top is the list, replace it when a
//                     // detail is already on top. Tapping a different
//                     // video updates the right pane in place instead
//                     // of stacking three entries.
//                     context.pushOrReplaceTop(
//                       VideoPlayerView(collectionId: id, fileName: fileName),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _VideoPlayerScreen extends StatelessWidget {
//   const _VideoPlayerScreen({required this.fileName, this.showBack = true});
//   final String fileName;

//   /// In the absorbed master-detail layout, the detail pane has no
//   /// back arrow — popping happens via the list's selection state, not
//   /// a back gesture. Standalone (narrow), the back arrow is shown.
//   final bool showBack;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: const Color(0xFFEFB8BE),
//       child: Stack(
//         children: [
//           Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(
//                   Icons.play_arrow,
//                   size: 56,
//                   color: Color(0xFF8E2C3A),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Video Player View',
//                   style: TextStyle(
//                     color: const Color(0xFF8E2C3A).withValues(alpha: 0.9),
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'fileName: $fileName',
//                   style: const TextStyle(color: Colors.black87, fontSize: 13),
//                 ),
//               ],
//             ),
//           ),
//           if (showBack)
//             Positioned(
//               top: 8,
//               left: 8,
//               child: IconButton(
//                 onPressed: () => context.pop(),
//                 icon: const Icon(Icons.arrow_back, color: Color(0xFF8E2C3A)),
//                 tooltip: 'Back to collection',
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // Adaptive builder for the Test branch. Decides per page whether to
// // render standalone or absorb the route below into a side-by-side
// // master-detail. Called once per stack entry by the inner navigator.
// KaiselPageResult _testAdaptiveBuilder(
//   BuildContext context,
//   TestRoute route,
//   KaiselStackContext<TestRoute> ctx,
// ) {
//   final isWide = MediaQuery.of(context).size.width >= _wideBreakpoint;

//   return switch ((ctx.previous, route, isWide)) {
//     // TestHome is always standalone.
//     (_, TestHome(), _) => const KaiselStandalonePage(_TestHomeScreen()),

//     // VideoPlayerView pushed on top of CollectionView at wide widths
//     // → absorb the list into the detail as side-by-side panes. The
//     // list pane gets the selected fileName so it can highlight the
//     // active row.
//     (CollectionView(:final id), VideoPlayerView(:final fileName), true) =>
//       KaiselAbsorbingPage(
//         widget: _MasterDetailScaffold(
//           master: _CollectionScreen(id: id, selectedFileName: fileName),
//           detail: _VideoPlayerScreen(fileName: fileName, showBack: false),
//         ),
//         absorbing: 1,
//       ),

//     // CollectionView always renders the list. Standalone at narrow,
//     // standalone at wide when nothing is selected.
//     (_, CollectionView(:final id), _) => KaiselStandalonePage(
//       _CollectionScreen(id: id),
//     ),

//     // VideoPlayerView at narrow widths, or on top of something other
//     // than CollectionView: standalone, with the back button shown.
//     (_, VideoPlayerView(:final fileName), _) => KaiselStandalonePage(
//       _VideoPlayerScreen(fileName: fileName),
//     ),
//   };
// }

// /// Side-by-side scaffold used when CollectionView absorbs
// /// VideoPlayerView at wide widths. Master gets a fixed proportion,
// /// detail takes the rest, with a thin divider between.
// class _MasterDetailScaffold extends StatelessWidget {
//   const _MasterDetailScaffold({required this.master, required this.detail});
//   final Widget master;
//   final Widget detail;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         SizedBox(width: 280, child: master),
//         const VerticalDivider(width: 1, color: Colors.black26),
//         Expanded(child: detail),
//       ],
//     );
//   }
// }

// // Shell host
// //
// // Holds three branches, each with its own typed router. The shell's
// // own chrome (sidebar + breadcrumb) is built by the chrome builder.

// // Declarative branches: the shell creates, owns, and disposes the per-branch
// // routers for us. (Before, this was a StatefulWidget holding three
// // `KaiselRouter`s + a `BranchedShellRouter` and disposing all four by hand, and
// // threading the routers through the chrome.)
// class _ShellHost extends StatelessWidget {
//   const _ShellHost();

//   @override
//   Widget build(BuildContext context) {
//     return KaiselBranchedShell.specs(
//       branches: [
//         KaiselBranchSpec<HomeRoute>(
//           initial: const HomeView(),
//           builder: (context, route) => switch (route) {
//             HomeView() => const _HomeScreen(),
//           },
//         ),
//         KaiselBranchSpec<LibraryRoute>(
//           initial: const LibraryView(),
//           builder: (context, route) => switch (route) {
//             LibraryView() => const _LibraryScreen(),
//           },
//         ),
//         KaiselBranchSpec<TestRoute>.adaptive(
//           initial: const TestHome(),
//           builder: _testAdaptiveBuilder,
//         ),
//       ],
//       chromeBuilder: (context, active, branchContent, switchBranch) {
//         return _AppChrome(
//           activeBranchIndex: active,
//           onSwitchBranch: switchBranch,
//           branchContent: branchContent,
//         );
//       },
//     );
//   }
// }

// // Chrome (sidebar + breadcrumb + back/forward)

// class _AppChrome extends StatelessWidget {
//   const _AppChrome({
//     required this.activeBranchIndex,
//     required this.onSwitchBranch,
//     required this.branchContent,
//   });

//   final int activeBranchIndex;
//   final void Function(int) onSwitchBranch;
//   final Widget branchContent;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: const Color(0xFF2A2A2A),
//       child: SafeArea(
//         child: Column(
//           children: [
//             // Outer chrome: app title bar with browser-style back/forward.
//             // These are decorative in the demo — they could be wired to a
//             // global navigation history if you wanted browser-like behavior
//             // across branch switches.
//             Container(
//               height: 36,
//               color: const Color(0xFF1A1A1A),
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: const Row(
//                 children: [
//                   Icon(Icons.web_asset, size: 14, color: Colors.white54),
//                   SizedBox(width: 12),
//                   Text(
//                     '[DEV] Media Cataloguer',
//                     style: TextStyle(color: Colors.white, fontSize: 13),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               height: 40,
//               color: const Color(0xFF5A5A5A),
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Row(
//                 children: [
//                   IconButton(
//                     iconSize: 18,
//                     color: Colors.white54,
//                     onPressed: null,
//                     icon: const Icon(Icons.arrow_back_ios_new),
//                   ),
//                   IconButton(
//                     iconSize: 18,
//                     color: Colors.white54,
//                     onPressed: null,
//                     icon: const Icon(Icons.arrow_forward_ios),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(child: const _InnerNavBar()),
//                   IconButton(
//                     iconSize: 14,
//                     color: Colors.white70,
//                     tooltip: 'Sign out',
//                     onPressed: () {
//                       // Return to login surface. The page wrapper cross-fades.
//                       context.set(const [LoginRoute()]);
//                     },
//                     icon: const Icon(Icons.logout),
//                   ),
//                 ],
//               ),
//             ),
//             // Sidebar + content area
//             Expanded(
//               child: Row(
//                 children: [
//                   _Sidebar(
//                     activeBranchIndex: activeBranchIndex,
//                     onSwitchBranch: onSwitchBranch,
//                   ),
//                   Expanded(child: branchContent),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Inner back/forward + breadcrumb. Hooks into the active branch's
// /// router so the back arrow pops within the current branch only.
// class _InnerNavBar extends StatelessWidget {
//   const _InnerNavBar();

//   @override
//   Widget build(BuildContext context) {
//     // The shell exposes the active branch via context.shell() — no need to
//     // hold the per-branch routers. It notifies on branch switches and on
//     // active-stack changes, so the breadcrumb stays live.
//     final shell = context.shell();

//     return ListenableBuilder(
//       listenable: shell,
//       builder: (context, _) {
//         final current = shell.current;
//         final (label, path, canPop) = _describeActive(
//           shell.activeBranch,
//           current,
//         );
//         return Row(
//           children: [
//             IconButton(
//               iconSize: 16,
//               color: canPop ? Colors.white : Colors.white38,
//               onPressed: canPop ? current.pop : null,
//               icon: const Icon(Icons.arrow_back_ios_new),
//             ),
//             IconButton(
//               iconSize: 16,
//               color: Colors.white38,
//               onPressed: null,
//               icon: const Icon(Icons.arrow_forward_ios),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Row(
//                 children: [
//                   Text(
//                     label,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(color: Colors.white, fontSize: 13),
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     path,
//                     style: const TextStyle(color: Colors.white54, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   /// Returns (human-readable label, URL path, whether back is enabled) for the
//   /// active branch [activeBranchIndex] and its [current] router.
//   (String, String, bool) _describeActive(
//     int activeBranchIndex,
//     KaiselNavigator current,
//   ) {
//     switch (activeBranchIndex) {
//       case 0:
//         return ('Home', '/home', current.canPop);
//       case 1:
//         return ('Library', '/library', current.canPop);
//       default:
//         return switch (current.stack.last) {
//           CollectionView(:final id) => (
//             'Collection - $id',
//             '/collection/$id',
//             true,
//           ),
//           VideoPlayerView(:final collectionId, :final fileName) => (
//             'Collection - $collectionId',
//             '/collection/$collectionId/$fileName',
//             true,
//           ),
//           _ => ('Test', '/test', false),
//         };
//     }
//   }
// }

// class _Sidebar extends StatelessWidget {
//   const _Sidebar({
//     required this.activeBranchIndex,
//     required this.onSwitchBranch,
//   });

//   final int activeBranchIndex;
//   final void Function(int) onSwitchBranch;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       color: const Color(0xFF7A7A7A),
//       padding: const EdgeInsets.symmetric(vertical: 40),
//       child: Column(
//         children: [
//           _SidebarItem(
//             icon: Icons.home,
//             label: 'Home',
//             selected: activeBranchIndex == 0,
//             onTap: () => onSwitchBranch(0),
//           ),
//           const SizedBox(height: 24),
//           _SidebarItem(
//             icon: Icons.account_balance,
//             label: 'Library',
//             selected: activeBranchIndex == 1,
//             onTap: () => onSwitchBranch(1),
//           ),
//           const SizedBox(height: 24),
//           _SidebarItem(
//             icon: Icons.folder,
//             label: 'test',
//             selected: activeBranchIndex == 2,
//             onTap: () => onSwitchBranch(2),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SidebarItem extends StatelessWidget {
//   const _SidebarItem({
//     required this.icon,
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   final IconData icon;
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: selected ? Colors.black : Colors.black87,
//               size: 20,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 color: selected ? Colors.black : Colors.black87,
//                 fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // App
// //
// // The whole router setup is one top-level value: no StatefulWidget, no manual
// // KaiselRouterDelegate, no hand-rolled parser, no dispose. (This replaced a
// // ~30-line StatefulWidget plus a `_NoopParser` class.)

// final _config = KaiselRouterConfig<AppRoute>(
//   initial: const LoginRoute(),
//   builder: (context, route) => switch (route) {
//     LoginRoute() => const _LoginScreen(),
//     ShellHost() => const _ShellHost(),
//   },
//   pageWrapper: _appPageWrapper,
// );

// void main() {
//   runApp(
//     MaterialApp.router(
//       title: '[DEV] Media Cataloguer',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF00D4FF),
//           brightness: Brightness.light,
//         ),
//         useMaterial3: true,
//       ),
//       routerConfig: _config,
//     ),
//   );
// }
