import 'package:flutter/material.dart';
import 'package:quran_sahaba/l10n/app_localizations.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({
    super.key,
    required this.onToggleLocale,
    required this.onToggleTheme,
    required this.onToggleChrome,
    required this.isDarkMode,
    required this.isBottomBarVisible,
  });

  final VoidCallback onToggleLocale;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleChrome;
  final bool isDarkMode;
  final bool isBottomBarVisible;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(AppLocalizations.of(context)!.language),
          onTap: onToggleLocale,
        ),
        ListTile(
          leading: Icon(isDarkMode ? Icons.dark_mode : Icons.sunny),
          title: Text(AppLocalizations.of(context)!.theme),
          onTap: onToggleTheme,
        ),
        ListTile(
          leading: Icon(
            isBottomBarVisible ? Icons.visibility_off : Icons.visibility,
          ),
          title: Text(AppLocalizations.of(context)!.showHideChrome),
          onTap: onToggleChrome,
        ),
      ],
    );
  }
}
