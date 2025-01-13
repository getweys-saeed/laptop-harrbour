import 'package:flutter/material.dart';
import 'package:laptop_harbour/screens/cart/cart.dart';
import 'package:laptop_harbour/screens/fravourite/favourate.dart';
import 'package:laptop_harbour/screens/index/index.dart';
import 'package:laptop_harbour/screens/profile/profile.dart';
import 'package:laptop_harbour/screens/shop/shop.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  void _navigateToScreen(BuildContext context, int index) {
    Widget destination;

    switch (index) {
      case 0:
        destination = IndexPage();
        break;
      case 1:
        destination = FavouratePage();
        break;
      case 2:
        destination = CartPage();
        break;
      case 3:
        destination = ProfileWidget();
        break;
      default:
        destination = IndexPage();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black45,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourite'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) => _navigateToScreen(context, index),
    );
  }
}
