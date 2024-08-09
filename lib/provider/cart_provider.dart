import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shop/widgets/items/cart_item.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  List<CartItem> get items => [..._items];
  bool get isLoading => _isLoading;

  Future<String?> _getUserId() async {
    final user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null;
  }

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    final userId = await _getUserId();
    if (userId == null) {
      _items = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    final cartCollection = FirebaseFirestore.instance.collection('carts');
    final docSnapshot = await cartCollection.doc(userId).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      _items = (data['items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item))
          .toList();
    } else {
      _items = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveCartItems() async {
    final userId = await _getUserId();
    if (userId == null) {
      return;
    }

    final cartCollection = FirebaseFirestore.instance.collection('carts');
    final cartData = _items.map((item) => item.toJson()).toList();
    await cartCollection.doc(userId).set({'items': cartData});
  }

  void addItem(String productId, String title, double price, String? imageUrl,
      String color, String size) {
    int existingIndex = _items.indexWhere((item) =>
        item.productId == productId &&
        item.color == color &&
        item.size == size);

    if (existingIndex != -1) {
      _items[existingIndex] = CartItem(
        id: _items[existingIndex].id,
        productId: productId,
        title: title,
        price: price,
        quantity: _items[existingIndex].quantity + 1,
        imageUrl: imageUrl ?? 'https://via.placeholder.com/50',
        color: color,
        size: size,
      );
    } else {
      _items.add(
        CartItem(
          id: DateTime.now().toString(),
          productId: productId,
          title: title,
          price: price,
          quantity: 1,
          imageUrl: imageUrl ?? 'https://via.placeholder.com/50',
          color: color,
          size: size,
        ),
      );
    }

    _saveCartItems();
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    _saveCartItems();
    notifyListeners();
  }

  double get totalAmount {
    double total = 0.0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void clear() {
    _items = [];
    _saveCartItems();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    _saveCartItems();
    notifyListeners();
  }
}
