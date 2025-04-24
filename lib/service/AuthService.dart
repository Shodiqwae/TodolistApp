import 'dart:convert';
import 'package:http/http.dart' as http;

class Authservice{
  final String baseUrl = 'http://192.168.211.57:8000/api'; // Ganti dengan URL API Anda

  Future<Map<String, dynamic>> register(String name, String email, String password, String passwordConfirmation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );
    return jsonDecode(response.body);
  }

   Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

//   Future<Map<String, dynamic>> getProfile(String token) async {
//   final response = await http.get(
//     Uri.parse('$baseUrl/profile'),
//     headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     },
//   );

//   if (response.statusCode == 200) {
//     return jsonDecode(response.body);
//   } else {
//     return {
//       'success': false,
//       'message': 'Failed to fetch profile',
//     };
//   }
// }


  // Future<Map<String, dynamic>> updateProfile(
  //     String token, String name, String email) async {
  //   final response = await http.put(
  //     Uri.parse('$baseUrl/profile/update'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode({'name': name, 'email': email}),
  //   );
  //   return jsonDecode(response.body);
  // }

 





}
