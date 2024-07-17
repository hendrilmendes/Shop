import 'package:flutter/material.dart';
import 'package:shop/widgets/cart_item.dart';

class Order {
  final String id;
  final String customerName;
  final String address;
  final String paymentMethod;
  final double amount;
  final DateTime date;
  final List<CartItem> items;

  Order({
    required this.id,
    required this.customerName,
    required this.address,
    required this.paymentMethod,
    required this.amount,
    required this.date,
    required this.items,
  });
}

class OrderProvider with ChangeNotifier {
  final String userId;
  final List<Order> _orders = [];

  OrderProvider(this.userId);

  List<Order> get orders => [..._orders];

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }
}
