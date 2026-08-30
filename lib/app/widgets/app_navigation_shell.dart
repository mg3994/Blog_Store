import 'package:blogstore/app/router/router.dart';
import 'package:kaisel/kaisel.dart';
import 'package:material_ui/material_ui.dart';

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
      SettingsMasterRoute() => 3,
      AppSettingRoute() => 3,
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
      return Scaffold(
        body: Row(
          children: [
            Container(
              width: 88,
              color: theme.colorScheme.surfaceContainer,
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
                  Expanded(
                    child: NavigationRail(
                      selectedIndex: selectedIndex,
                      onDestinationSelected: (index) => _onItemTapped(context, index),
                      backgroundColor: Colors.transparent,
                      labelType: NavigationRailLabelType.all,
                      useIndicator: true,
                      indicatorColor: theme.colorScheme.primaryContainer,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: Text('Home'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.storefront_outlined),
                          selectedIcon: Icon(Icons.storefront),
                          label: Text('Store'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.edit_note_outlined),
                          selectedIcon: Icon(Icons.edit_note),
                          label: Text('Drafts'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.settings_outlined),
                          selectedIcon: Icon(Icons.settings),
                          label: Text('Settings'),
                        ),
                      ],
                    ),
                  ),
                ],
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
