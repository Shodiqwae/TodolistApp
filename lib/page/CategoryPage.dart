import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:todolist_app/model/taskmodel.dart';
import 'dart:convert';

import 'package:todolist_app/page/DetailTask.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int? selectedCategoryId;

  List<dynamic> categories = [];

@override
void initState() {
  super.initState();
  fetchCategories();
  fetchAllTasks(); // tampilkan semua task secara default
}


Future<void> fetchAllTasks() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/tasks')); // sesuaikan URL
  if (response.statusCode == 200) {
    setState(() {
      tasks = json.decode(response.body);
    });
  } else {
    throw Exception('Failed to load all tasks');
  }
}

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/categories')); // sesuaikan URL
    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }
  Color getPriorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case 'urgent':
      return const Color.fromARGB(255, 255, 44, 44);
    case 'high':
      return Colors.deepOrange;
    case 'netral':
      return Colors.amber[700]!;
    case 'low':
      return Colors.green;
    default:
      return Colors.grey; // fallback/default
  }
}


  List<dynamic> tasks = [];

Future<void> fetchTasksByCategory(int categoryId) async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/tasks/category/$categoryId'));
  if (response.statusCode == 200) {
    setState(() {
      tasks = json.decode(response.body);
    });
  } else {
    throw Exception('Failed to load tasks');
  }
}

  void showAddCategoryDialog() {
  String categoryName = '';
  String selectedIcon = 'label';
  Color selectedColor = Colors.blue;

  final iconChoices = {
    'work': Icons.work,
    'person': Icons.person,
    'flight': Icons.flight,
    'computer': Icons.computer,
    'home': Icons.home,
    'shopping_cart': Icons.shopping_cart,
    'health_and_safety': Icons.health_and_safety,
    'school': Icons.school,
    'attach_money': Icons.attach_money,
    'people': Icons.people,
    'movie': Icons.movie,
    'restaurant': Icons.restaurant,
    'label': Icons.label,
  };
  

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Tambah Kategori'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nama Kategori'),
                onChanged: (value) {
                  categoryName = value;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedIcon,
                decoration: InputDecoration(labelText: 'Pilih Icon'),
                items: iconChoices.keys.map((iconName) {
                  return DropdownMenuItem<String>(
                    value: iconName,
                    child: Row(
                      children: [
                        Icon(iconChoices[iconName]),
                        SizedBox(width: 10),
                        Text(iconName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedIcon = value!;
                  });
                },
              ),
              SizedBox(height: 10),
              Text('Pilih Warna'),
              BlockPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) {
                  selectedColor = color;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              if (categoryName.isEmpty) return;

              final body = {
                'name': categoryName,
                'user_id': '6', // ganti sesuai user_id yang aktif
                'icon': selectedIcon,
                'color': '#${selectedColor.value.toRadixString(16).substring(2)}',
              };

              final response = await http.post(
                Uri.parse('http://10.0.2.2:8000/api/categories'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(body),
              );

              if (response.statusCode == 200 || response.statusCode == 201) {
                Navigator.pop(context);
                fetchCategories(); // refresh
              } else {
                print('Gagal simpan kategori');
              }
            },
            child: Text('Simpan'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Color.fromRGBO(27, 86, 253, 0.98),
            ),
            child: Column(
              children: [
                const SizedBox(height: 33),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 27)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        "Category",
                        style: TextStyle(color: Colors.white, fontFamily: "Mont-SemiBold", fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 180),
                      alignment: Alignment.centerRight,
                      child: IconButton(onPressed: () {
                            showAddCategoryDialog();
                      }, icon: Icon(Icons.add,color: Colors.white,size: 30,)))
                  ],
                ),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
  // Tombol All
  GestureDetector(
    onTap: () {
      setState(() {
        selectedCategoryId = null; // null berarti All
        fetchAllTasks();
      });
    },
    child: Container(
      margin: const EdgeInsets.only(left: 15),
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: selectedCategoryId == null ? Colors.transparent : Colors.black12,
        border: Border.all(
          color: selectedCategoryId == null ? Colors.blue : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: const Text(
        "All",
        style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: "Mont-SemiBold"),
      ),
    ),
  ),

  ...categories.map((category) {
    final int id = category['id'];
    final String name = category['name'];
    final String colorHex = category['color'] ?? '#888888';
    final Color color = Color(int.parse(colorHex.substring(1, 7), radix: 16) + 0xFF000000);
    final bool isSelected = selectedCategoryId == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategoryId = id;
          fetchTasksByCategory(id);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.transparent : color,
          border: Border.all(color: color, width: 3),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          name,
          style: TextStyle(
color: Colors.white,
            fontSize: 16,
            fontFamily: "Mont-SemiBold",
          ),
        ),
      ),
    );
  }).toList(),
],



                  ),
                ),
              ],
            ),
          ),
          Expanded(
  child: ListView.builder(
    itemCount: tasks.length,
itemBuilder: (context, index) {
final task = Task.fromJson(tasks[index]);
  final String namaTask = task.name;
final String priority = task.priority;
final String categoryName = task.categoryName;
final String colorHex = task.categoryColor.isNotEmpty ? task.categoryColor : '#888888';
final Color categoryColor = Color(int.parse(colorHex.substring(1, 7), radix: 16) + 0xFF000000);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
    child: InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailTask(task: task)));
      },
      child: Container(
        decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1), // warna bayangan dengan transparansi
        spreadRadius: 2, // seberapa jauh bayangan menyebar
        blurRadius: 1, // seberapa blur bayangannya
        offset: Offset(0, 3), // posisi bayangan (x, y)
      ),
        ],
      ),
      
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      namaTask,
                      style: TextStyle(fontSize: 18, fontFamily: "Mont-Bold"),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      categoryName,
                      style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: "Mont-SemiBold"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
            Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
      color: getPriorityColor(priority),
      borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
      "Priority: $priority",
      style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: "Mont-SemiBold"),
        ),
      ),
      
            ],
          ),
        ),
      ),
    ),
  );
},

  ),
)

        ],
      ),
    );
  }
}
