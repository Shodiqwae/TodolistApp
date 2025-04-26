import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todolist_app/model/taskmodel.dart';

Future<List<Task>> fetchTasks(String token) async {
  final response = await http.get(
    Uri.parse('http://192.168.41.57:8000/api/tasks'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // kirim token di sini
    },
  );

  print('Response Status: ${response.statusCode}');
  print('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    try {
      List jsonResponse = json.decode(response.body);
      if (jsonResponse.isEmpty) return [];
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    } catch (e) {
      throw Exception('Failed to parse tasks: $e');
    }
  } else {
    throw Exception('Failed to load tasks. Status code: ${response.statusCode}');
  }
}



Future<bool> createTask(
  String? taskName,
  int? categoryId,
  String? priority,
  String token, // Tambahkan token di parameter
) async {
  final url = Uri.parse('http://192.168.41.57:8000/api/tasks');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Kirim token ke Laravel
    },
    body: json.encode({
      'nama': taskName,
      'category_id': categoryId,
      'priority': priority,
    }),
  );

  if (response.statusCode == 201) {
    return true;
  } else {
    print('Failed to create task: ${response.body}');
    return false;
  }
}



