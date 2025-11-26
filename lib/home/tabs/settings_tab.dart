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
    required this.showTasbih,
    required this.onToggleTasbih,
    required this.onOpenTafseerLibrary,
  });

  final VoidCallback onToggleLocale;
  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;
  final bool showTasbih;
  final VoidCallback onToggleTasbih;
  final VoidCallback onOpenTafseerLibrary;

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
        ListTile(
          leading: const Icon(Icons.radio_button_checked),
          title: Text(AppLocalizations.of(context)!.showTasbih),
          subtitle: Text(AppLocalizations.of(context)!.tasbihCounterDescription),
          trailing: Switch(
            value: showTasbih,
            onChanged: (_) => onToggleTasbih(),
          ),
          onTap: onToggleTasbih,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.library_books),
          title: Text(AppLocalizations.of(context)!.tafseerLibrary),
          subtitle: Text('Download and manage tafseer sources'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onOpenTafseerLibrary,
        ),
      ],
    );
  }
}
