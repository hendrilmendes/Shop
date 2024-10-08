import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
      id: json['id']?.toString() ?? '',
      customerName: json['customerName']?.toString() ??
          '', // Handle null for customerName
      address: json['address']?.toString() ?? '',
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class OrderProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  OrderProvider() {
    _loadOrders();
  }

  Future<String?> _getUserId() async {
    final user = _auth.currentUser;
    final userId = user?.uid;
    if (kDebugMode) {
      print('Obtendo User ID: $userId');
    }
    return userId;
  }

  Future<void> addOrder(Order order) async {
    final userId = await _getUserId();
    if (userId == null) {
      if (kDebugMode) {
        print('User not authenticated');
      }
      return;
    }

    if (kDebugMode) {
      print('User ID: $userId');
    }

    try {
      await _createOrdersCollection();
      await _createUserOrdersDocument(userId);

      final userOrdersDoc = FirebaseFirestore.instance
          .collection('orders')
          .doc(userId)
          .collection('userOrders');
      await userOrdersDoc.add(order.toJson());

      _orders.add(order);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding order: $e');
      }
    }
  }

  Future<void> _loadOrders() async {
    final userId = await _getUserId();
    if (userId == null) {
      _orders.clear();
      notifyListeners();
      return;
    }

    final ordersCollection = FirebaseFirestore.instance.collection('orders');
    try {
      final ordersSnapshot =
          await ordersCollection.doc(userId).collection('userOrders').get();

      if (kDebugMode) {
        print('Orders snapshot size: ${ordersSnapshot.size}');
      }

      if (ordersSnapshot.docs.isEmpty) {
        _orders.clear();
        notifyListeners();
        return;
      }

      _orders.clear();
      for (var doc in ordersSnapshot.docs) {
        try {
          _orders.add(Order.fromJson(doc.data()));
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing order data: $e');
          }
        }
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading orders: $e');
      }
    }
  }

  Future<void> _createOrdersCollection() async {
    final ordersCollection = FirebaseFirestore.instance.collection('orders');

    try {
      final ordersSnapshot = await ordersCollection.get();

      if (ordersSnapshot.docs.isEmpty) {
        if (kDebugMode) {
          print('Criando coleção "orders"');
        }
        // Adiciona um documento com dados iniciais para garantir que a coleção seja criada
        await ordersCollection.doc('initial').set({'created': true});
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating orders collection: $e');
      }
    }
  }

  Future<void> _createUserOrdersDocument(String userId) async {
    final userOrdersDoc = FirebaseFirestore.instance
        .collection('orders')
        .doc(userId)
        .collection('userOrders');

    try {
      final userOrdersSnapshot = await userOrdersDoc.get();

      if (userOrdersSnapshot.docs.isEmpty) {
        if (kDebugMode) {
          print('Criando documento "userOrders" para usuário $userId');
        }
        // Adiciona um documento com dados iniciais para garantir que a coleção seja criada
        await userOrdersDoc.doc('initial').set({'created': true});
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user orders document: $e');
      }
    }
  }

  Future<void> loadOrders() async {
    await _loadOrders();
  }
}
