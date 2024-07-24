import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryProvider with ChangeNotifier {
  List<String> _categories = ['Todos']; // Inclua 'Todos' como categoria padrão

  List<String> get categories {
    return [..._categories];
  }

  Future<void> fetchCategories() async {
    const url =
        'http://45.174.192.150:3000/api/categories'; // Substitua pelo seu IP local
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> extractedData = json.decode(response.body);
        _categories = ['Todos'] +
            extractedData.cast<String>(); // Adicione 'Todos' no início da lista
        notifyListeners();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      rethrow;
    }
  }
}
