import 'package:material_ui/material_ui.dart';

class SettingsMasterScreen extends StatelessWidget {
  const SettingsMasterScreen({super.key, this.selectedSetting = 'appearance', this.onSelectSetting});

  final String selectedSetting;
  final ValueChanged<String>? onSelectSetting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              decoration: InputDecoration(
                hintText: 'Search settings',
                prefixIcon: const Icon(Icons.search),
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
          _SettingsCategoryTile(
            icon: Icons.person_outline,
            title: 'General',
            subtitle: 'Profile, preferences',
            isSelected: selectedSetting == 'general',
            onTap: () => onSelectSetting?.call('general'),
          ),
          const SizedBox(height: 8),
          _SettingsCategoryTile(
            icon: Icons.palette_outlined,
            title: 'Appearance',
            subtitle: 'Theme, colors',
            isSelected: selectedSetting == 'appearance',
            onTap: () => onSelectSetting?.call('appearance'),
          ),
          const SizedBox(height: 8),
          _SettingsCategoryTile(
            icon: Icons.notifications_none,
            title: 'Notifications',
            subtitle: 'Alerts, sounds',
            isSelected: selectedSetting == 'notifications',
            onTap: () => onSelectSetting?.call('notifications'),
          ),
          const SizedBox(height: 8),
          _SettingsCategoryTile(
            icon: Icons.lock_outline,
            title: 'Privacy & Security',
            subtitle: 'Passwords, access',
            isSelected: selectedSetting == 'privacy',
            onTap: () => onSelectSetting?.call('privacy'),
          ),
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
