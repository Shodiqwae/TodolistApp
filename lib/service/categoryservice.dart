import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todolist_app/model/category.dart';

class CategoryService {
  // Ganti dengan URL API Laravel Anda
  final String baseUrl = 'http://10.0.2.2:8000/api';
  
  // Method untuk mengambil semua kategori
  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));
    
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Category> categories = body.map((item) => Category.fromJson(item)).toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }
  
  // Method untuk membuat kategori baru
  Future<Category> createCategory(String name, int userId, String? icon, String? color) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'user_id': userId,
        'icon': icon,
        'color': color,
      }),
    );
    
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Category.fromJson(data['data']);
    } else {
      throw Exception('Failed to create category');
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