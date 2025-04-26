import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/model/taskmodel.dart';
import 'package:todolist_app/page/CalenderPage.dart';
import 'package:todolist_app/page/HistoryPage.dart';
import 'package:todolist_app/page/Home.dart';
import 'package:todolist_app/page/TaskFormCreate.dart';
import 'package:todolist_app/page/TaskWidget.dart';
import 'package:todolist_app/service/tasksservice.dart';

class TaskPage extends StatefulWidget {
  final String token;

  const TaskPage({
    super.key,
    required this.token,
  });

  @override
  State<TaskPage> createState() => _TaskState();
}

class _TaskState extends State<TaskPage> {
  TextEditingController _searchController =
      TextEditingController(); // Menambahkan controller untuk pencarian
  List<Task> filteredTasks = [];
  late String _token;
  late Future<List<Task>> futureTasks;

  int _currentIndex = 1;
  @override
  void initState() {
    super.initState();
    _token = widget.token;
    futureTasks = fetchTasks(_token);
    loadTasks();
  }

  void _searchTasks(String query) {
    setState(() {
      futureTasks = fetchTasks(_token).then((tasks) => tasks
          .where(
              (task) => task.name.toLowerCase().contains(query.toLowerCase()))
          .toList());
    });
  }

  void loadTasks() {
    setState(() {
      futureTasks = fetchTasks(_token); // fungsi dari TaskService atau semacamnya
    });
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Future.delayed(Duration(milliseconds: 750), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      token: _token,
                    )),
          );
        });

        break;
      case 1:
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(235, 235, 235, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0xFF0118D8), 
            Color(0xFF1B56FD), 
              ])),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            "MyTask",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontFamily: "Mont-Bold"),
                          )),
                   
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 380,
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14)),
                        child: TextFormField(
                          controller: _searchController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Search task...',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: _searchTasks,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
               height: 620,
              child: Expanded(
                child: SingleChildScrollView(
                  child: TaskWidget(
                    futuretasks: futureTasks,
                    token: _token,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Menampilkan form untuk membuat task
          showDialog(
            context: context,
            builder: (context) => TaskFormDialog(
              onTaskCreated: loadTasks, token: _token,
            ),
          );
        },
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Color(0xFF1B56FD),
      ),
      bottomNavigationBar: BottomBarBubble(
        color: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: Color(0xFF1B56FD),
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
