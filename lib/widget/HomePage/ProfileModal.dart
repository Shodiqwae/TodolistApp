import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:todolist_app/page/login.dart';

class ProfileModal extends StatefulWidget {
  final String token;

  ProfileModal({required this.token});

  @override
  _ProfileModalState createState() => _ProfileModalState();
}

class _ProfileModalState extends State<ProfileModal> {
  late String _token;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _token = widget.token; // Ambil token dari widget
    _loadProfile();
  }

  // Fungsi untuk memuat data profile
  Future<void> _loadProfile() async {
    try {
      var profile = await getProfile();

      if (profile != null && profile.containsKey('data') && profile['data'] != null) {
        nameController.text = profile['nama'];
        emailController.text = profile['email'];
      } 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading profile: $e')));
    }
  }

  // Fungsi untuk mengambil data profile
  Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/getprofile'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {

        nameController.text = data['nama'];  // Menyimpan nama ke controller
        emailController.text = data['email'];  // Menyimpan email ke controller
      });
      return data;
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  // Fungsi untuk update profile
Future<void> _updateProfile() async {
  final response = await http.put(
    Uri.parse('http://10.0.2.2:8000/api/updateprofile'),
    headers: {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    },
    body: {
      'nama': nameController.text,
      'email': emailController.text,
    },
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
    Navigator.pop(context);
  } else {
    // Print the error response for debugging
    print('Update failed: ${response.body}');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile')));
  }
}

  // Fungsi untuk logout
  Future<void> _logout() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/logout'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      // Navigate to login page or clear user session
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to logout')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Profile'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _updateProfile();
          },
          child: Text('Update'),
        ),
        TextButton(
          onPressed: () {
            _logout();
          },
          child: Text('Logout'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
