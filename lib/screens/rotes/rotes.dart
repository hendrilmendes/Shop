import 'package:flutter/material.dart';
import 'package:shop/screens/cart/cart.dart';
import 'package:shop/screens/favorites/favorites.dart';
import 'package:shop/screens/home/home.dart';
import 'package:shop/screens/orders/orders.dart';
import 'package:shop/screens/settings/settings.dart';
import 'package:shop/widgets/bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children:  <Widget>[
          const HomeScreen(),
          const OrdersScreen(),
          const CartScreen(),
          const FavoritesScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationContainer(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
