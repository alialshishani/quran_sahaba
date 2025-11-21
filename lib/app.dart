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
    final lightBase = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white,
        brightness: Brightness.light,
      ),
    );
    final darkBase = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.black,
        brightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran Image Viewer',
      themeMode: _themeMode,
      theme: lightBase.copyWith(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: lightBase.colorScheme.copyWith(
          primary: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
          inversePrimary: Colors.black87,
        ),
        appBarTheme: lightBase.appBarTheme.copyWith(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      darkTheme: darkBase.copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: darkBase.colorScheme.copyWith(
          primary: Colors.white,
          surface: Colors.black,
          onSurface: Colors.white,
          inversePrimary: Colors.white70,
        ),
        appBarTheme: darkBase.appBarTheme.copyWith(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
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
