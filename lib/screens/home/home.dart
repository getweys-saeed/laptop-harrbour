import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:laptop_harbour/config/colors.dart';
import 'package:laptop_harbour/globals/asset_path.dart';
import 'package:laptop_harbour/screens/login/login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      AssetPath.homeLogo,
      AssetPath.appLogo,
      AssetPath.homeLogo,
      AssetPath.appLogo,
    ];

    return Scaffold(
      backgroundColor: secondaryColor,
      body: Column(
        children: [
          const SizedBox(height: 50),
          Expanded(
              child: CarouselSlider(
                  items: imagePaths
                      .map((e) => Center(
                            child: Image.asset(e),
                          ))
                      .toList(),
                  options: CarouselOptions(
                      initialPage: 0,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 2),
                      enlargeCenterPage: true))),
          const SizedBox(height: 20),
          Text(
            "Welcome To Laptop Harbour",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              shadows: [
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ],
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(primaryColor),
                foregroundColor: WidgetStatePropertyAll(Colors.white)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: const Text(
              "Get Started",
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
