import 'package:flutter/material.dart';
import 'package:shop/widgets/cart_item.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items {
    return [..._items];
  }

  void addItem(String productId, String title, double price) {
    int existingIndex =
        _items.indexWhere((item) => item.productId == productId);

    if (existingIndex != -1) {
      _items[existingIndex] = CartItem(
        id: _items[existingIndex].id,
        productId: productId,
        title: title,
        price: price,
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      _items.add(
        CartItem(
          id: DateTime.now().toString(),
          productId: productId,
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.productId == productId);
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
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }
}
