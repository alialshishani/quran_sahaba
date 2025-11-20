import 'package:flutter/material.dart';

import 'home/home_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

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
      home: MyHomePage(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleTheme: () {
          setState(() {
            _themeMode =
                _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
          });
        },
      ),
    );
  }
}
