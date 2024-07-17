import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/provider/order_provider.dart';
import 'package:shop/provider/products_provider.dart'; // Importe ProductProvider aqui
import 'package:shop/screens/cart/cart.dart';
import 'package:shop/screens/home/home.dart';
import 'package:shop/screens/orders/orders.dart';
import 'package:shop/screens/product_details/product_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = 'user123';

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(userId),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (ctx) => const HomeScreen(),
          '/cart': (ctx) => const CartScreen(),
          '/order': (ctx) => const OrdersScreen(),
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
        },
      ),
    );
  }
}
