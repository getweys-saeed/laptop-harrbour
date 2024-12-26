import 'package:flutter/material.dart';

import 'package:laptop_harbour/config/theme.dart';
import 'package:laptop_harbour/screens/home/home.dart';
import 'package:laptop_harbour/screens/index/index.dart';
import 'package:laptop_harbour/screens/login/login.dart';

import 'package:laptop_harbour/screens/profile/profile.dart';
import 'package:laptop_harbour/screens/register/register.dart';

import 'package:laptop_harbour/screens/splash/splash_screen.dart';
import 'package:laptop_harbour/widgets/custom_input.dart';

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
      home: Scaffold(body: IndexPage()),
    );
  }
}
