import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/api/api.dart';

class CategoryProvider with ChangeNotifier {
  List<String> _categories = ['Todos']; // Inclua 'Todos' como categoria padrão

  List<String> get categories {
    return [..._categories];
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/categories'));
      if (response.statusCode == 200) {
         final List<dynamic> categoriesJson = json.decode(response.body);
        _categories = ['Todos'] +
            categoriesJson.cast<String>(); // Adicione 'Todos' no início da lista
        notifyListeners();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      rethrow;
    }
  }
}
