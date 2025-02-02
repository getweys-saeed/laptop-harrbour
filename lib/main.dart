import 'package:flutter/material.dart';
import 'package:laptop_harbour/config/theme.dart';
import 'package:laptop_harbour/screens/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      themeMode: ThemeMode.system,
      darkTheme: darkTheme,
      home: Scaffold(body: SplashScreen()),
    );
  }
}
