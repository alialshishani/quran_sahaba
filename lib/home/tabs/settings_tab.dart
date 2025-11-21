import 'package:flutter/material.dart';
import 'package:quran_sahaba/l10n/app_localizations.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({
    super.key,
    required this.onToggleLocale,
    required this.onToggleTheme,
    required this.isDarkMode,
    required this.locale,
    required this.onLocaleChanged,
  });

  final VoidCallback onToggleLocale;
  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(AppLocalizations.of(context)!.language),
          trailing: DropdownButton<Locale>(
            value: locale,
            items: const [
              DropdownMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: Locale('ar'),
                child: Text('العربية'),
              ),
            ],
            onChanged: (newLocale) {
              if (newLocale != null) {
                onLocaleChanged(newLocale);
              }
            },
          ),
        ),
        ListTile(
          leading: Icon(isDarkMode ? Icons.dark_mode : Icons.sunny),
          title: Text(AppLocalizations.of(context)!.theme),
          onTap: onToggleTheme,
        ),
      ],
    );
  }
}
