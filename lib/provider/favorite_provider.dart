import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shop/models/product.dart';
import 'package:shop/widgets/items/favorite_item.dart';

class FavoritesProvider with ChangeNotifier {
  final List<FavoriteItem> _favorites = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<FavoriteItem> get favorites => [..._favorites];

  FavoritesProvider() {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        clearFavorites();
      } else {
        init();
      }
    });
  }

  Future<String?> _getUserId() async {
    final user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    return null;
  }

  Future<void> init() async {
    final user = _auth.currentUser;
    if (user == null) {
      _favorites.clear();
      notifyListeners();
      return;
    }

    final userId = user.uid;
    final favoritesCollection =
        FirebaseFirestore.instance.collection('favorites');
    final docSnapshot = await favoritesCollection.doc(userId).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      final List<dynamic> favoritesData = data['items'] ?? [];
      _favorites.clear();
      _favorites.addAll(favoritesData.map((jsonItem) =>
          FavoriteItem.fromMap(jsonItem as Map<String, dynamic>)));
    } else {
      _favorites.clear();
    }
    notifyListeners();
  }

  Future<void> addFavorite(Product product) async {
    final userId = await _getUserId();
    if (userId == null) {
      if (kDebugMode) {
        print('User not authenticated');
      }
      return; // Se o usuário não estiver autenticado, não adiciona o favorito
    }

    final item = FavoriteItem(
      id: product.id,
      title: product.title,
      price: product.price,
      imageUrl: product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
    );

    _favorites.add(item);

    final favoritesCollection =
        FirebaseFirestore.instance.collection('favorites');
    final favoritesData = _favorites.map((item) => item.toMap()).toList();
    try {
      await favoritesCollection.doc(userId).set({'items': favoritesData});
      if (kDebugMode) {
        print('Favorite added successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding favorite: $e');
      }
    }

    notifyListeners();
  }

  Future<void> removeFavorite(String id) async {
    final userId = await _getUserId();
    if (userId == null) {
      if (kDebugMode) {
        print('User not authenticated');
      }
      return; // Se o usuário não estiver autenticado, não remove o favorito
    }

    _favorites.removeWhere((item) => item.id == id);

    final favoritesCollection =
        FirebaseFirestore.instance.collection('favorites');
    final favoritesData = _favorites.map((item) => item.toMap()).toList();
    try {
      await favoritesCollection.doc(userId).set({'items': favoritesData});
    } catch (e) {
      if (kDebugMode) {
        print('Error removing favorite: $e');
      }
    }

    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.any((item) => item.id == id);
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
