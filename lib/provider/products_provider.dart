import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/api/api.dart';
import 'package:shop/models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  Future<void> fetchProducts() async {
    const url = '$apiUrl/api/products';
    try {
      if (kDebugMode) {
        print('Fetching products from: $url');
      }
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List<dynamic>;
        final List<Product> loadedProducts = [];

        for (var productData in extractedData) {
          final product = Product.fromJson(productData);
          if (kDebugMode) {
            print('Product object: $product'); // Log do objeto Produto
          }
          loadedProducts.add(product);
        }

        _products = loadedProducts;
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching products: $error');
      }
      rethrow;
    }
  }

  Product findById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }
}
