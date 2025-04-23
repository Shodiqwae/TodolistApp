// // import 'package:flutter/material.dart';
// // import 'package:todolist_app/service/tasksservice.dart';
// // import 'package:todolist_app/model/taskmodel.dart';

// // class TaskPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Task List'),
// //       ),
// //       body: TaskWidget(),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           // Menampilkan form untuk membuat task
// //           showDialog(
// //             context: context,
// //             builder: (context) => TaskFormDialog(),
// //           );
// //         },
// //         child: Icon(Icons.add),
// //         backgroundColor: Colors.blue,
// //       ),
// //     );
// //   }
// // }
// import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
// import 'package:bottom_bar_matu/bottom_bar_item.dart';
// import 'package:flutter/material.dart';
// import 'package:todolist_app/model/category.dart';
// import 'package:todolist_app/model/taskmodel.dart';
// import 'package:todolist_app/page/Task.dart';
// import 'package:todolist_app/page/TaskFormCreate.dart';
// import 'package:todolist_app/page/TaskWidget.dart';
// import 'package:todolist_app/service/categoryservice.dart';
// import 'package:todolist_app/service/tasksservice.dart';
// import 'package:todolist_app/widget/HomePage/HomeAppBar.dart';
// import 'package:todolist_app/widget/HomePage/CategoryWidget.dart'; // Import the new widget

// class HomePage extends StatefulWidget {
//   final String token;
//   const HomePage({required this.token});
//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late String _token;
//   late Future<List<Task>> futureTasks;
  
//   final CategoryService _categoryService = CategoryService();
//   List<Category> categories = [];
//   bool isLoading = true;
//   int _currentIndex = 0;
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _token = widget.token;
//     futureTasks = fetchTasks();
//     loadTasks();
//     _loadCategories();
//   }

//   void loadTasks() {
//     setState(() {
//       futureTasks = fetchTasks(); // fungsi dari TaskService atau semacamnya
//     });
//   }

//   Future<void> _loadCategories() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });
//       print('Fetching categories with token: $_token');
//       final fetchedCategories = await _categoryService.getCategories(_token);
//       print('Received categories: ${fetchedCategories.length}');
//       // Print first category details if available
//       if (fetchedCategories.isNotEmpty) {
//         print('First category: ${fetchedCategories[0].name}, User ID: ${fetchedCategories[0].userId}');
//       }
      
//       setState(() {
//         categories = fetchedCategories;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading categories: $e');
//       setState(() {
//         isLoading = false;
//       });
      
//       if (_isInitialized && context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Gagal memuat kategori: $e'))
//         );
//       }
//     }
    
//     _isInitialized = true;
//   }

//   void _onNavTap(int index) {
//     if (index == _currentIndex) return;

//     setState(() {
//       _currentIndex = index;
//     });

//     switch (index) {
//       case 0:
//         // do nothing, sudah di home
//         break;
//       case 1:
//         Future.delayed(Duration(milliseconds: 750), () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => TaskPage(token: _token,)),
//           );
//         });
//         break;
//     }
//   }

//   Future<void> _refreshTasks() async {
//     setState(() {
//       futureTasks = fetchTasks(); // Memanggil ulang fetchTasks untuk mendapatkan data terbaru
//     });
//     await _loadCategories(); // Also refresh categories
//   }


  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(235, 235, 235, 1),
//       body: RefreshIndicator(
//         onRefresh: _refreshTasks,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               HomeAppbar(),
//               SizedBox(height: 20),
              
//               // Use the new CategoryWidget here
//               CategoryWidget(
//                 token: _token,
//                 categories: categories,
//                 refreshCategories: _loadCategories,
//                 isLoading: isLoading,
//               ),
                  
//               SizedBox(height: 20),
//               Row(
//                 children: [
//                   SizedBox(width: 20),
//                   Text("Task", style: TextStyle(color: Colors.black, fontFamily: "Mont-SemiBold", fontSize: 17))
//                 ],
//               ),
//               SizedBox(height: 10),
//               TaskWidget(futuretasks: futureTasks,)
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Menampilkan form untuk membuat task
//           showDialog(
//             context: context,
//             builder: (context) => TaskFormDialog(onTaskCreated: loadTasks,),
//           );
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.blue,
//       ),
//             bottomNavigationBar: BottomBarBubble(
//     color: const Color.fromARGB(255, 255, 255, 255),
//     backgroundColor: Color.fromRGBO(19, 86, 148, 1),
//         items: [
//           BottomBarItem(
//             iconData: Icons.home,
//           ),
//           BottomBarItem(
//             iconData: Icons.task_sharp,
//             // label: 'Chat',
//           ),
//           BottomBarItem(
//             iconData: Icons.calendar_month,
//             // label: 'Notification',
//           ),
//           BottomBarItem(
//             iconData: Icons.calendar_month,
//             // label: 'Calendar',
//           ),
//         ],
//          onSelect: _onNavTap,
//         selectedIndex: _currentIndex,
//       ),
//     );
//   }
// }