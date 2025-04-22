import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todolist_app/model/taskmodel.dart';

Future<List<Task>> fetchTasks() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/tasks'));
  print('Response Status: ${response.statusCode}');
  print('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    try {
      // Parse the JSON response
      List jsonResponse = json.decode(response.body);

      // Handle cases where the response is empty
      if (jsonResponse.isEmpty) {
        return [];
      }

      // Map JSON response to Task objects
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    } catch (e) {
      // If there is an error while parsing the JSON, throw an exception
      throw Exception('Failed to parse tasks: $e');
    }
  } else {
    // If the response is not successful, throw an exception
    throw Exception('Failed to load tasks. Status code: ${response.statusCode}');
  }
}


Future<bool> createTask(String? taskName, int? categoryId, String? priority) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/tasks'); // Ganti dengan URL API kamu
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'nama': taskName,
      'category_id': categoryId, // Kirimkan ID kategori
      'priority': priority,
      'user_id': 6, // Ganti dengan ID user yang sesuai
    }),
  );

  if (response.statusCode == 201) {
    return true; // Task berhasil dibuat
  } else {
    print('Failed to create task: ${response.body}'); // Cetak pesan error untuk debugging
    return false; // Task gagal dibuat
  }
}


