import 'package:flutter/material.dart';
import 'package:todolist_app/model/model_board.dart';
import 'package:todolist_app/model/taskmodel.dart';
import 'package:todolist_app/page/DetailTask.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TodayTaskList extends StatefulWidget {
  final Future<List<Board>> future;

  const TodayTaskList({super.key, required this.future});

  @override
  State<TodayTaskList> createState() => _TodayTaskListState();
}

class _TodayTaskListState extends State<TodayTaskList> {
  Future<Task> fetchTaskById(int taskId) async {
  // Implementasikan API atau logic untuk mengambil Task berdasarkan taskId
  final response = await http.get(Uri.parse('http://192.168.211.57:8000/api/task/$taskId'));
  if (response.statusCode == 200) {
    return Task.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load task');
  }
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Board>>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No tasks for today'));
        }

        final boards = snapshot.data!;
        
        // Calculate total height needed
        final double itemHeight = 110.0; // Height of each container
        final double verticalMargin = 16.0; // Total vertical margin per item (8 top + 8 bottom)
        final double totalHeight = boards.length * (itemHeight + verticalMargin);
        
        // Wrap CustomScrollView in a SizedBox with fixed height
        return SizedBox(
          height: totalHeight, // Set fixed height
          child: CustomScrollView(
            
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true, // Important!
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final board = boards[index];
                    return InkWell(
                      
                      onTap: () async {
                         final task = await fetchTaskById(board.tasksId!);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailTask(task: task )));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        height: 118,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    board.title,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontFamily: "Mont-SemiBold",
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  child: Text(
                                    board.statusId == 1 ? 'Pending' : 'In Progress',
                                    style: TextStyle(
                                      color: board.statusId == 1 ? Colors.orange : Colors.blue,
                                      fontSize: 16,
                                      fontFamily: "Mont-SemiBold",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    board.description ?? "No description",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 129, 129, 129),
                                      fontSize: 13,
                                      fontFamily: "Mont-SemiBold",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    'Due Date: ${board.dueDate?.day}-${board.dueDate?.month}-${board.dueDate?.year}',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 42, 42),
                                      fontSize: 15,
                                      fontFamily: "Mont-SemiBold",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: boards.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}