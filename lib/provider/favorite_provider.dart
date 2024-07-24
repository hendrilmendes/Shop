import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/models/product.dart';
import 'package:shop/widgets/items/favorite_item.dart';

class FavoritesProvider with ChangeNotifier {
  static const _favoritesKey = 'favorites';
  final List<FavoriteItem> _favorites = [];

  List<FavoriteItem> get favorites => [..._favorites];

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson != null) {
      final List<dynamic> decodedList = json.decode(favoritesJson);
      _favorites.addAll(decodedList.map((jsonItem) =>
          FavoriteItem.fromMap(jsonItem as Map<String, dynamic>)));
    }
    notifyListeners();
  }

  Future<void> addFavorite(Product product) async {
    final item = FavoriteItem(
      id: product.id,
      title: product.title,
      price: product.price,
      imageUrl: product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
    );
    _favorites.add(item);
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson =
        json.encode(_favorites.map((item) => item.toMap()).toList());
    await prefs.setString(_favoritesKey, favoritesJson);
    notifyListeners();
  }

  Future<void> removeFavorite(String id) async {
    _favorites.removeWhere((item) => item.id == id);
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson =
        json.encode(_favorites.map((item) => item.toMap()).toList());
    await prefs.setString(_favoritesKey, favoritesJson);
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.any((item) => item.id == id);
  }
}
