import 'dart:convert';
import 'package:flutter/foundation.dart';
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
            categoriesJson.map((category) {
              return category['name'].toString();
            }).toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Erro ao carregar categorias: $error');
      }
      rethrow;
    }
  }
}
