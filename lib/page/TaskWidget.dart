import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:todolist_app/model/taskmodel.dart';
import 'package:todolist_app/page/DetailTask.dart';

class TaskWidget extends StatefulWidget {
  final Future<List<Task>> futuretasks;
  final String token;

  TaskWidget({required this.futuretasks, required this.token});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  List<Task> currentTasks = [];

  Future<void> deleteTask(int id) async {
    final response = await http.delete(
      Uri.parse('http://192.168.41.57:8000/api/tasks/$id'),
    );

    if (response.statusCode == 200) {
      setState(() {
        currentTasks.removeWhere((task) => task.id == id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus task')),
      );
    }
  }

  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi"),
        content: Text("Yakin ingin menghapus task ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Tidak"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteTask(id);
            },
            child: Text("Iya"),
          ),
        ],
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return FutureBuilder<List<Task>>(
    future: widget.futuretasks,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return ShimmerLoading();
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('No tasks available.'));
      } else {
        currentTasks = snapshot.data!;
        currentTasks.sort((a, b) {
          int getPriorityValue(String priority) {
            switch (priority.toLowerCase()) {
              case 'urgent':
                return 1;
              case 'high':
                return 2;
              case 'netral':
                return 3;
              case 'low':
                return 4;
              default:
                return 5;
            }
          }

          return getPriorityValue(a.priority).compareTo(getPriorityValue(b.priority));
        });

        return Container(
          color: const Color.fromARGB(255, 234, 234, 234),
          height: 620, // Ensure the container fills the screen height
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(10),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = currentTasks[index];
                      Color priorityColor;
                      switch (task.priority.toLowerCase()) {
                        case 'urgent':
                          priorityColor = Colors.red;
                          break;
                        case 'high':
                          priorityColor = Colors.orange;
                          break;
                        case 'netral':
                          priorityColor = Colors.blue;
                          break;
                        case 'low':
                          priorityColor = Colors.green;
                          break;
                        default:
                          priorityColor = Colors.grey;
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (_) => DetailTask(task: task)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Material(
                            elevation: 6,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          task.name,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Mont-SemiBold",
                                            fontSize: 17,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: task.categoryColor.isNotEmpty
                                                    ? Color(int.parse('0xFF${task.categoryColor.substring(1)}'))
                                                    : Colors.grey,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                task.categoryName,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Mont-SemiBold",
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Priority: ${task.priority}",
                                      style: TextStyle(
                                        color: priorityColor,
                                        fontSize: 15,
                                        fontFamily: "Mont-SemiBold",
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_month_outlined, size: 20, color: Colors.black54),
                                        SizedBox(width: 6),
                                        Text(
                                          task.createdAt.split('T')[0],
                                          style: TextStyle(
                                            fontFamily: "Mont-SemiBold",
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: currentTasks.length,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    },
  );
}

}

class ShimmerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: 4,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          height: 10,
                          color: Colors.white,
                        ),
                        Container(
                          width: 60,
                          height: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: 80,
                      height: 10,
                      color: Colors.white,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.calendar_month_outlined, size: 20, color: Colors.black54),
                        SizedBox(width: 6),
                        Container(
                          width: 50,
                          height: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
