import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/widgets/items/cart_item.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  CartProvider() {
    _loadCartItems(); // Carrega itens do carrinho ao iniciar o provider
  }

  Future<void> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart') ?? '[]';

    try {
      final List<dynamic> decodedData = json.decode(cartData);
      _items = decodedData
          .map((item) => CartItem(
                id: item['id'] ?? '',
                productId: item['productId'] ?? '',
                title: item['title'] ?? '',
                quantity: item['quantity'] ?? 0,
                price: item['price']?.toDouble() ?? 0.0,
                imageUrl: item['imageUrl'] ??
                    'https://via.placeholder.com/50', // Valor padrão para imagemUrl
              ))
          .toList();
    } catch (e) {
      // Se a decodificação falhar, exiba um erro ou defina `_items` como uma lista vazia.
      _items = [];
      if (kDebugMode) {
        print('Erro ao carregar itens do carrinho: $e');
      }
    }

    notifyListeners();
  }

  Future<void> _saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = json.encode(_items
        .map((item) => {
              'id': item.id,
              'productId': item.productId,
              'title': item.title,
              'quantity': item.quantity,
              'price': item.price,
              'imageUrl': item.imageUrl,
            })
        .toList());
    await prefs.setString('cart', cartData);
  }

  void addItem(String productId, String title, double price, String? imageUrl) {
    int existingIndex =
        _items.indexWhere((item) => item.productId == productId);

    if (existingIndex != -1) {
      _items[existingIndex] = CartItem(
        id: _items[existingIndex].id,
        productId: productId,
        title: title,
        price: price,
        quantity: _items[existingIndex].quantity + 1,
        imageUrl: imageUrl ?? 'https://via.placeholder.com/50',
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
        ),
      );
    }

    _saveCartItems(); // Salva o estado atualizado do carrinho
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    _saveCartItems(); // Salva o estado atualizado do carrinho
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
    _saveCartItems(); // Salva o estado atualizado do carrinho
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    _saveCartItems(); // Salva o estado atualizado do carrinho
    notifyListeners();
  }
}
