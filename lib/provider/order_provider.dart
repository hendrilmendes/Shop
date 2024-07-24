import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/widgets/items/cart_item.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'address': address,
      'paymentMethod': paymentMethod,
      'amount': amount,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerName: json['customerName'],
      address: json['address'],
      paymentMethod: json['paymentMethod'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }
}

class OrderProvider with ChangeNotifier {
  final String userId;
  final List<Order> _orders = [];

  OrderProvider(this.userId) {
    _loadOrders();
  }

  List<Order> get orders => [..._orders];

  Future<void> addOrder(Order order) async {
    _orders.add(order);
    notifyListeners();
    await _saveOrders();
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> ordersJson =
        _orders.map((order) => order.toJson()).toList();
    prefs.setString('orders', json.encode(ordersJson));
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getString('orders') ?? '[]';
    final List<dynamic> ordersList = json.decode(ordersJson);
    _orders.addAll(
      ordersList.map((jsonOrder) => Order.fromJson(jsonOrder)).toList(),
    );
    notifyListeners();
  }
}
