import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/model/category.dart';
import 'package:todolist_app/model/taskmodel.dart';
import 'package:todolist_app/page/Task.dart';
import 'package:todolist_app/page/TaskFormCreate.dart';
import 'package:todolist_app/page/TaskWidget.dart';
import 'package:todolist_app/service/categoryservice.dart';
import 'package:todolist_app/service/tasksservice.dart';
import 'package:todolist_app/widget/HomePage/HomeAppBar.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Task>> futureTasks;
  
  final CategoryService _categoryService = CategoryService();
  List<Category> categories = [];
  bool isLoading = true;
  int _currentIndex = 0;
  
  // Nilai default untuk kategori baru
  IconData selectedIcon = Icons.label;
  Color selectedColor = Colors.blue;
  final TextEditingController categoryNameController = TextEditingController();

  


  // Map icon untuk pilihan icon di dialog
  final Map<String, IconData> iconOptions = {
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

  @override
  void initState() {
    super.initState();
    _loadCategories();
    futureTasks = fetchTasks();
        loadTasks();

  }
  void loadTasks() {
    setState(() {
      futureTasks = fetchTasks(); // fungsi dari TaskService atau semacamnya
    });
  }
  @override
  void dispose() {
    categoryNameController.dispose();
    super.dispose();
    
  }

  Future<void> _loadCategories() async {
    try {
      setState(() {
        isLoading = true;
      });
      final fetchedCategories = await _categoryService.getCategories();
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat kategori: $e'))
      );
    }
  }

  // Method untuk membuat kategori baru
  Future<void> _createCategory() async {
    if (categoryNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama kategori tidak boleh kosong'))
      );
      return;
    }

    try {
      // Konversi warna ke format string hex
      String colorHex = '#${selectedColor.value.toRadixString(16).substring(2)}';
      
      // Konversi icon ke nama string
String iconName = iconOptions.entries
    .firstWhere((entry) => entry.value == selectedIcon, 
               orElse: () => MapEntry('label', Icons.label))
    .key.toLowerCase();
      
      // Gunakan ID user dari user yang sedang login
      int userId = 6; // Ganti dengan ID user yang sebenarnya
      
      await _categoryService.createCategory(
        categoryNameController.text, 
        userId, 
        iconName, 
        colorHex
      );
      
      // Refresh daftar kategori
      await _loadCategories();
      
      // Reset nilai input
      categoryNameController.clear();
      selectedIcon = Icons.label;
      selectedColor = Colors.blue;
      
      // Tutup dialog
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategori berhasil dibuat'))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat kategori: $e'))
      );
    }
  }

  // Method untuk menampilkan dialog pembuatan kategori
  void _showAddCategoryDialog() {
    // Reset nilai input setiap kali dialog dibuka
    setState(() {
      selectedIcon = Icons.label;
      selectedColor = Colors.blue;
      categoryNameController.clear();
    });
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Tambah Kategori'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: categoryNameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Kategori',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Icon:'),
                        InkWell(
                          onTap: () {
                            // Pilih icon dalam dialog yang sama tanpa menutup dialog utama
                            _selectIcon(context, setDialogState);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(selectedIcon, size: 30),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Warna:'),
                        InkWell(
                          onTap: () {
                            // Pilih warna dalam dialog yang sama tanpa menutup dialog utama
                            _selectColor(context, setDialogState);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: selectedColor,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Batal'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Simpan'),
                  onPressed: () {
                    _createCategory();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Method untuk memilih icon dengan pendekatan yang lebih baik
  void _selectIcon(BuildContext context, StateSetter setDialogState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Icon'),
          content: Container(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: iconOptions.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                String key = iconOptions.keys.elementAt(index);
                IconData iconData = iconOptions[key]!;
                return InkWell(
                  onTap: () {
                    // Update icon yang dipilih menggunakan StateSetter
                    setDialogState(() {
                      selectedIcon = iconData;
                    });
                    // Update juga state utama
                    setState(() {
                      selectedIcon = iconData;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(iconData, size: 30),
                      SizedBox(height: 5),
                      Text(key, style: TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Method untuk memilih warna dengan pendekatan yang lebih baik
  void _selectColor(BuildContext context, StateSetter setDialogState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color pickerColor = selectedColor;
        return AlertDialog(
          title: Text('Pilih Warna'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                pickerColor = color;
              },
              pickerAreaHeightPercent: 0.8,
              displayThumbColor: true,
              enableAlpha: false,
              paletteType: PaletteType.hsv,
              pickerAreaBorderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Pilih'),
              onPressed: () {
                // Update warna yang dipilih menggunakan StateSetter
                setDialogState(() {
                  selectedColor = pickerColor;
                });
                // Update juga state utama
                setState(() {
                  selectedColor = pickerColor;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // do nothing, sudah di home
        break;
      case 1:
        Future.delayed(Duration(milliseconds: 750), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TaskPage()),
          );
        });
        break;
    }
  }
  Future<void> _refreshHomePage() async {
  // Logika untuk memperbarui data
  try {
    // Misalnya, memuat data dari server
    await Future.delayed(Duration(seconds: 2)); // Simulasi delay
    // Update data di sini
    setState(() {
      // Perbarui state jika diperlukan
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Halaman berhasil disegarkan')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal menyegarkan halaman: $e')),
    );
  }
}
  Future<void> _refreshTasks() async {
    setState(() {
      futureTasks = fetchTasks(); // Memanggil ulang fetchTasks untuk mendapatkan data terbaru
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(235, 235, 235, 1),
      body: RefreshIndicator(
         onRefresh: _refreshTasks,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeAppbar(),
              SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text('Category', style: TextStyle(fontFamily: "Mont-SemiBold", color: Colors.black, fontSize: 17)),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(right: 33),
                  //   child: Text('See All', style: TextStyle(fontFamily: "Mont-SemiBold", color: Color.fromRGBO(97, 119, 140, 1), fontSize: 17)),
                  // ),
                ],
              ),
              SizedBox(height: 10),
              
              // Tampilkan loading atau list kategori
              isLoading 
                ? Center(child: CircularProgressIndicator())
                : Container(
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 45,
                          runSpacing: 10,
                          children: [
                            // Tampilkan kategori yang ada
                            ...categories.take(categories.length > 8 ? 8 : categories.length).map((cat) => Tooltip(
                              message: cat.name,
                              child: Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: cat.getColor(),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(cat.getIconData(), color: Colors.white),
                                      ],
                                    ),   
                                  ],
                                ),
                              ),
                            )),
                            
                            // Tampilkan tombol tambah jika kategori kurang dari 8
                            if (categories.length < 8)
                              Tooltip(
                                message: "Tambah Kategori",
                                child: InkWell(
                                  onTap: _showAddCategoryDialog,
                                  child: Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.grey, width: 1),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add, color: Colors.black54),
                                          ],
                                        ),   
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ]
                        )
                      ],
                    ),
                  ),
                  
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text("Task", style: TextStyle(color: Colors.black, fontFamily: "Mont-SemiBold", fontSize: 17))
                ],
              ),
              SizedBox(height: 10),
              TaskWidget(futuretasks: futureTasks,)
            ],
          ),
        ),
      ),
            bottomNavigationBar: BottomBarBubble(
    color: const Color.fromARGB(255, 255, 255, 255),
    backgroundColor: Color.fromRGBO(19, 86, 148, 1),
        items: [
          BottomBarItem(
            iconData: Icons.home,
          ),
          BottomBarItem(
            iconData: Icons.task_sharp,
            // label: 'Chat',
          ),
          BottomBarItem(
            iconData: Icons.calendar_month,
            // label: 'Notification',
          ),
          BottomBarItem(
            iconData: Icons.calendar_month,
            // label: 'Calendar',
          ),
        ],
         onSelect: _onNavTap,
        selectedIndex: _currentIndex,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Menampilkan form untuk membuat task
          showDialog(
            context: context,
            builder: (context) => TaskFormDialog(onTaskCreated: loadTasks,),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
  
    );
  }
}