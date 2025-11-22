import 'package:flutter/material.dart';
import 'package:quran_sahaba/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/home_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en');
  static const _themePrefKey = 'theme_mode';
  static const _localePrefKey = 'locale';

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    _loadLocale();
  }

  @override
  Widget build(BuildContext context) {
    // Light theme with warm, elegant colors
    final lightColorScheme = ColorScheme.light(
      primary: const Color(0xFF1B5E20), // Deep green - Islamic color
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFC8E6C9), // Light green
      onPrimaryContainer: const Color(0xFF003300),

      secondary: const Color(0xFF6D4C41), // Warm brown
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFD7CCC8), // Light brown
      onSecondaryContainer: const Color(0xFF3E2723),

      tertiary: const Color(0xFF004D40), // Teal accent
      onTertiary: Colors.white,

      error: const Color(0xFFB00020),
      onError: Colors.white,

      surface: const Color(0xFFFAFAFA), // Soft white
      onSurface: const Color(0xFF1C1B1F),
      surfaceContainerHighest: const Color(0xFFE7E0EC),

      outline: const Color(0xFF79747E),
      shadow: Colors.black26,
    );

    // Dark theme with rich, elegant colors
    final darkColorScheme = ColorScheme.dark(
      primary: const Color(0xFF81C784), // Soft green
      onPrimary: const Color(0xFF003300),
      primaryContainer: const Color(0xFF2E7D32), // Medium green
      onPrimaryContainer: const Color(0xFFC8E6C9),

      secondary: const Color(0xFFBCAAA4), // Soft brown
      onSecondary: const Color(0xFF3E2723),
      secondaryContainer: const Color(0xFF5D4037), // Medium brown
      onSecondaryContainer: const Color(0xFFD7CCC8),

      tertiary: const Color(0xFF80CBC4), // Soft teal
      onTertiary: const Color(0xFF003300),

      error: const Color(0xFFCF6679),
      onError: const Color(0xFF690005),

      surface: const Color(0xFF1C1B1F), // Rich dark
      onSurface: const Color(0xFFE6E1E5),
      surfaceContainerHighest: const Color(0xFF36343B),

      outline: const Color(0xFF938F99),
      shadow: Colors.black54,
    );

    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: lightColorScheme.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.surface,
        foregroundColor: lightColorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: lightColorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        surfaceTintColor: lightColorScheme.primary.withValues(alpha: 0.05),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightColorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: lightColorScheme.primary,
        unselectedItemColor: lightColorScheme.onSurface.withValues(alpha: 0.6),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: darkColorScheme.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: darkColorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: darkColorScheme.surfaceContainerHighest,
        surfaceTintColor: darkColorScheme.primary.withValues(alpha: 0.08),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkColorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkColorScheme.surfaceContainerHighest,
        selectedItemColor: darkColorScheme.primary,
        unselectedItemColor: darkColorScheme.onSurface.withValues(alpha: 0.6),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran Image Viewer',
      themeMode: _themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      home: MyHomePage(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleTheme: () {
          final nextMode = _themeMode == ThemeMode.dark
              ? ThemeMode.light
              : ThemeMode.dark;
          _updateThemeMode(nextMode);
        },
        onToggleLocale: () {
          final nextLocale = _locale.languageCode == 'en'
              ? const Locale('ar')
              : const Locale('en');
          _updateLocale(nextLocale);
        },
        locale: _locale,
        onLocaleChanged: _updateLocale,
      ),
    );
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_themePrefKey);
    final mode = stored == 'dark' ? ThemeMode.dark : ThemeMode.light;
    if (mode != _themeMode) {
      if (!mounted) return;
      setState(() => _themeMode = mode);
    }
  }

  Future<void> _updateThemeMode(ThemeMode mode) async {
    setState(() {
      _themeMode = mode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _themePrefKey,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_localePrefKey);
    final locale = stored == 'ar' ? const Locale('ar') : const Locale('en');
    if (locale != _locale) {
      if (!mounted) return;
      setState(() => _locale = locale);
    }
  }

  Future<void> _updateLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _localePrefKey,
      locale.languageCode,
    );
  }
}
