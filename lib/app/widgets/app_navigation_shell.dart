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
