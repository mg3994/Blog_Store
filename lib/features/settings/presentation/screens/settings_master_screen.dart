import 'package:blogstore/app/helpers/extensions.dart';
import 'package:material_ui/material_ui.dart';

class SettingsCategoryItemData {
  const SettingsCategoryItemData({
    required this.id,
    required this.titleBuilder,
    required this.subtitleBuilder,
    required this.icon,
  });

  final String id;
  final String Function(BuildContext context) titleBuilder;
  final String Function(BuildContext context) subtitleBuilder;
  final IconData icon;
}

final List<SettingsCategoryItemData> kSettingsCategoryItems = [
  SettingsCategoryItemData(
    id: 'general',
    titleBuilder: (context) => context.l10n.settingsGeneralTitle,
    subtitleBuilder: (context) => context.l10n.settingsGeneralSubtitle,
    icon: Icons.person_outline,
  ),
  SettingsCategoryItemData(
    id: 'appearance',
    titleBuilder: (context) => context.l10n.settingsAppearanceTitle,
    subtitleBuilder: (context) => context.l10n.settingsAppearanceSubtitle,
    icon: Icons.palette_outlined,
  ),
  SettingsCategoryItemData(
    id: 'notifications',
    titleBuilder: (context) => context.l10n.settingsNotificationsTitle,
    subtitleBuilder: (context) => context.l10n.settingsNotificationsSubtitle,
    icon: Icons.notifications_none,
  ),
  SettingsCategoryItemData(
    id: 'privacy',
    titleBuilder: (context) => context.l10n.settingsPrivacyTitle,
    subtitleBuilder: (context) => context.l10n.settingsPrivacySubtitle,
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
  final void Function(BuildContext context, String setting)? onSelectSetting;

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

  void _clearSearch() {
    _searchController.clear();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  List<SettingsCategoryItemData> _getFilteredItems(BuildContext context) {
    if (_searchQuery.isEmpty) return kSettingsCategoryItems;
    return kSettingsCategoryItems.where((item) {
      final title = item.titleBuilder(context).toLowerCase();
      final subtitle = item.subtitleBuilder(context).toLowerCase();
      return title.contains(_searchQuery) || subtitle.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _getFilteredItems(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                context.l10n.settingsTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: context.l10n.searchSettings,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearSearch,
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
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        context.l10n.noSettingsFound,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return _SettingsCategoryTile(
                          icon: item.icon,
                          title: item.titleBuilder(context),
                          subtitle: item.subtitleBuilder(context),
                          isSelected: widget.selectedSetting == item.id,
                          onTap: (tileContext) => widget.onSelectSetting?.call(
                            tileContext,
                            item.id,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
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
  final void Function(BuildContext context) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = isSelected
        ? colorScheme.secondaryContainer
        : Colors.transparent;
    final iconColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;
    final textColor = isSelected
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurface;

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
        onTap: () => onTap(context),
      ),
    );
  }
}
