import 'dart:convert';
import 'package:http/http.dart' as http;

class Authservice{
  final String baseUrl = 'http://192.168.41.57:8000/api'; // Ganti dengan URL API Anda



   Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }


 





}
