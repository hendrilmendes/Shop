import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    const url = 'https://run.mocky.io/v3/72d2b42e-4c84-46d9-b404-fa05a5d181ad'; // Substitua pela URL do seu servidor
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _products = data.map((item) => Product.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      rethrow;
    }
  }

  Product findById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }
}
