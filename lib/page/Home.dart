import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/model/category.dart';
import 'package:todolist_app/model/model_board.dart';
import 'package:todolist_app/model/taskmodel.dart';
import 'package:todolist_app/page/CalenderPage.dart';
import 'package:todolist_app/page/CategoryPage.dart';
import 'package:todolist_app/page/HistoryPage.dart';
import 'package:todolist_app/page/Task.dart';
import 'package:todolist_app/page/TaskFormCreate.dart';
import 'package:todolist_app/page/TaskWidget.dart';
import 'package:todolist_app/service/categoryservice.dart';
import 'package:todolist_app/service/tasksservice.dart';
import 'package:todolist_app/widget/HomePage/CategoryWidget.dart';
import 'package:todolist_app/widget/HomePage/HomeAppBar.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:todolist_app/widget/HomePage/TodayTaskWidget.dart';

class HomePage extends StatefulWidget {
  final String token;

  HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _token;

  late Future<List<Task>> futureTasks;

  final CategoryService _categoryService = CategoryService();
  List<Category> categories = [];
  bool isLoading = true;
  int _currentIndex = 0;
  bool _isInitialized = false;

  // Nilai default untuk kategori baru
  IconData selectedIcon = Icons.label;
  Color selectedColor = Colors.blue;
  late Future<List<Board>> _todayTasks;

  final TextEditingController categoryNameController = TextEditingController();

  // Map icon untuk pilihan icon di dialog

  @override
  void initState() {
    super.initState();
    _token = widget.token; // <-- pindahkan ini ke atas dulu
    _loadCategories();
    futureTasks = fetchTasks();
    loadTasks();
    _todayTasks = getTodayTasks();
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
      print('Fetching categories with token: $_token');
      final fetchedCategories = await _categoryService.getCategories(_token);
      print('Received categories: ${fetchedCategories.length}');
      // Print first category details if available
      if (fetchedCategories.isNotEmpty) {
        print(
            'First category: ${fetchedCategories[0].name}, User ID: ${fetchedCategories[0].userId}');
      }

      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading categories: $e');
      setState(() {
        isLoading = false;
      });

      if (_isInitialized && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal memuat kategori: $e')));
      }
    }

    _isInitialized = true;
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
            MaterialPageRoute(
                builder: (context) => TaskPage(
                      token: _token,
                    )),
          );
        });
        break;
      case 2:
        Future.delayed(Duration(milliseconds: 750), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Historypage(
                      token: _token,
                    )),
          );
        });
        break;
                case 3:
         Future.delayed(Duration(milliseconds: 750), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CalendarPage(
                      token: _token,
                    )),
          );
        });
        break;
    }
  }

  Future<void> _refreshTodayTasks() async {
    setState(() {
      _todayTasks =
          getTodayTasks(); // Memanggil ulang fetchTasks untuk mendapatkan data terbaru
    });
  }

  Future<List<Board>> getTodayTasks() async {
    final String baseUrl = 'http://10.0.2.2:8000'; // Ganti dengan URL API kamu
    final response = await http.get(Uri.parse('$baseUrl/api/today-tasks'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((boardJson) => Board.fromJson(boardJson)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(235, 235, 235, 1),
      body: RefreshIndicator(
        onRefresh: _refreshTodayTasks,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeAppbar(
                token: _token,
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text('Category',
                        style: TextStyle(
                            fontFamily: "Mont-SemiBold",
                            color: Colors.black,
                            fontSize: 17)),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                    token: _token,
                                  )));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 33),
                      child: Text('See All',
                          style: TextStyle(
                              fontFamily: "Mont-SemiBold",
                              color: Color.fromRGBO(97, 119, 140, 1),
                              fontSize: 17)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Tampilkan loading atau list kategori
              CategoryWidget(
                token: _token,
                categories: categories,
                refreshCategories: _loadCategories,
                isLoading: isLoading,
              ),

              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Container(
                          margin: EdgeInsets.all(0),
                          child: Text("Today Task",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Mont-SemiBold",
                                  fontSize: 17)))
                    ],
                  ),
                  TodayTaskList(future: _todayTasks)
                ],
              ),

              // TaskWidget(futuretasks: futureTasks,)
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
            iconData: Icons.history,
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
    );
  }
}
