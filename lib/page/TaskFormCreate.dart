import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todolist_app/service/tasksservice.dart';

class TaskFormDialog extends StatefulWidget {
    final String token;

   final VoidCallback onTaskCreated;

  TaskFormDialog({required this.onTaskCreated, required this.token});
  @override
  _TaskFormDialogState createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _taskName;
  int? _selectedCategory;
  String? _priority = 'low';

  List<Map<String, dynamic>> _categories = []; // Menyimpan kategori dengan id dan nama

  // Fungsi untuk mengambil data kategori dari API Laravel
Future<void> _fetchCategories() async {
  final url = Uri.parse('http://192.168.211.57:8000/api/categories'); // Ganti dengan URL API kategori
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer ${widget.token}', // Pastikan token dikirim
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    setState(() {
      _categories = data.map((category) {
        return {'id': category['id'], 'name': category['name']};
      }).toList();
    });
  } else {
    throw Exception('Failed to load categories. Status code: ${response.statusCode}');
  }
}


  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Ambil data kategori saat widget diinisialisasi
  }

  // Fungsi untuk menyimpan task ke API
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        // Kirim data ke API untuk membuat task
    final response = await createTask(
  _taskName,
  _selectedCategory,
  _priority,
  widget.token, // Kirim token dari constructor
  );
        if (response != null) {
  widget.onTaskCreated(); // Memanggil callback
  Navigator.of(context).pop();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Task created successfully')),
  );
}
 else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create task')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Task'),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Task Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter task name';
                }
                return null;
              },
              onSaved: (value) => _taskName = value,
            ),
            DropdownButtonFormField<Map<String, dynamic>>(
  value: _selectedCategory != null
      ? _categories.firstWhere((category) => category['id'] == _selectedCategory)
      : null,
  hint: Text('Select Category'),
  items: _categories.map((category) {
    return DropdownMenuItem<Map<String, dynamic>>(
      value: category,
      child: Text(category['name']),
    );
  }).toList(),
  onChanged: (Map<String, dynamic>? value) {
    setState(() {
      _selectedCategory = value?['id']; // value['id'] = int
    });
  },
  onSaved: (value) => _selectedCategory = value?['id'],
),

            DropdownButtonFormField<String>(
              value: _priority,
              decoration: InputDecoration(labelText: 'Priority'),
              items: ['low', 'netral', 'high', 'urgent']
                  .map((priority) => DropdownMenuItem<String>(
                        value: priority,
                        child: Text(priority),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _priority = value;
                });
              },
              onSaved: (value) => _priority = value,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Menutup dialog tanpa simpan
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text('Create Task'),
        ),
      ],
    );
  }
}
