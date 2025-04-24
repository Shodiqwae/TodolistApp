import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todolist_app/model/category.dart';

class CategoryService {
  final String baseUrl = 'http://192.168.211.57:8000/api';
  
  // Method untuk mengambil kategori berdasarkan user yang login
Future<List<Category>> getCategories(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      // Print the error response for debugging
      print('Failed to load categories: ${response.body}');
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }
  
  // Method to create a new category
 Future<Category> createCategory(
    String name, 
    String token, 
    String icon, 
    String color
  ) async {
    // Debug info
    print('Creating category with token: $token');
    print('Category data: name=$name, icon=$icon, color=$color');
    
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json', // Add this line
      },
      body: jsonEncode({
        'name': name,
        'icon': icon,
        'color': color,
      }),
    );

    // Debug response
    print('createCategory response code: ${response.statusCode}');
    print('createCategory response body: ${response.body}');

    if (response.statusCode == 201) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create category: ${response.body}');
    }
  }

  
  // Method untuk mendapatkan detail kategori
  Future<Category> getCategoryDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/categories/$id'));
    
    if (response.statusCode == 200) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load category detail');
    }
  }
  
  // Method untuk update kategori
  Future<void> updateCategory(int id, String name, String? icon, String? color) async {
    final response = await http.put(
      Uri.parse('$baseUrl/categories/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'icon': icon,
        'color': color,
      }),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to update category');
    }
  }
  
  // Method untuk menghapus kategori
  Future<void> deleteCategory(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/categories/$id'));
    
    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }
}