import 'package:flutter/material.dart';

import 'home/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white,
        brightness: Brightness.light,
      ),
    );
    return MaterialApp(
      title: 'Quran Image Viewer',
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: baseTheme.colorScheme.copyWith(
          primary: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
          inversePrimary: Colors.black87,
        ),
        appBarTheme: baseTheme.appBarTheme.copyWith(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}
