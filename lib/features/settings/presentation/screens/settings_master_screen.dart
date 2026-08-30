import 'package:material_ui/material_ui.dart';

class SettingsCategoryItem {
  const SettingsCategoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}

const List<SettingsCategoryItem> kSettingsCategoryItems = [
  SettingsCategoryItem(
    id: 'general',
    title: 'General',
    subtitle: 'Profile, preferences',
    icon: Icons.person_outline,
  ),
  SettingsCategoryItem(
    id: 'appearance',
    title: 'Appearance',
    subtitle: 'Theme, colors',
    icon: Icons.palette_outlined,
  ),
  SettingsCategoryItem(
    id: 'notifications',
    title: 'Notifications',
    subtitle: 'Alerts, sounds',
    icon: Icons.notifications_none,
  ),
  SettingsCategoryItem(
    id: 'privacy',
    title: 'Privacy & Security',
    subtitle: 'Passwords, access',
    icon: Icons.lock_outline,
  ),
];

class SettingsMasterScreen extends StatefulWidget {
  const SettingsMasterScreen({
    super.key,
    this.selectedSetting = 'appearance',
    this.onSelectSetting,
  });

  final String selectedSetting;
  final ValueChanged<String>? onSelectSetting;

  @override
  State<SettingsMasterScreen> createState() => _SettingsMasterScreenState();
}

class _SettingsMasterScreenState extends State<SettingsMasterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  List<SettingsCategoryItem> get _filteredItems {
    if (_searchQuery.isEmpty) return kSettingsCategoryItems;
    return kSettingsCategoryItems.where((item) {
      final titleMatch = item.title.toLowerCase().contains(_searchQuery);
      final subtitleMatch = item.subtitle.toLowerCase().contains(_searchQuery);
      return titleMatch || subtitleMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search settings',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  'No settings found',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            for (int i = 0; i < filtered.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              _SettingsCategoryTile(
                icon: filtered[i].icon,
                title: filtered[i].title,
                subtitle: filtered[i].subtitle,
                isSelected: widget.selectedSetting == filtered[i].id,
                onTap: () => widget.onSelectSetting?.call(filtered[i].id),
              ),
            ],
        ],
      ),
    );
  }
}

class _SettingsCategoryTile extends StatelessWidget {
  const _SettingsCategoryTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = isSelected
        ? colorScheme.secondaryContainer
        : Colors.transparent;
    final iconColor = isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;
    final textColor = isSelected ? colorScheme.onSecondaryContainer : colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
