import 'package:flutter/material.dart';
import 'package:todolist_app/model/model_board.dart';
import 'package:todolist_app/model/taskmodel.dart';
import 'package:todolist_app/page/DetailTask.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart'; // Import shimmer package

class TodayTaskList extends StatefulWidget {
  final Future<List<Board>> future;
  final VoidCallback onRefreshNeeded;

  const TodayTaskList({
    super.key,
    required this.future,
    required this.onRefreshNeeded,
  });

  @override
  State<TodayTaskList> createState() => _TodayTaskListState();
}

class _TodayTaskListState extends State<TodayTaskList> {
  @override
  void initState() {
    super.initState();
    widget.future;
  }

  // Method to refresh the data
  void refreshData() {
    widget.onRefreshNeeded(); // Call the parent's refresh method
    setState(() {
      widget.future;
    });
  }

  Future<Task> fetchTaskById(int taskId) async {
    final response = await http.get(Uri.parse('http://192.168.41.57:8000/api/task/$taskId'));
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
  // Asumsikan tampilkan 5 shimmer item
  final int shimmerItemCount = 5;
  final double itemHeight = 110.0;
  final double verticalMargin = 16.0;
  final double totalHeight = shimmerItemCount * (itemHeight + verticalMargin);

  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: SizedBox(
      height: totalHeight,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: shimmerItemCount,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            height: 118,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    ),
  );
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
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailTask(task: task)),
                        );

                        // Check if we need to refresh data
                        if (result == true) {
                          refreshData();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        height: 118,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Shadow color with transparency
                              spreadRadius: 2, // Spread of the shadow
                              blurRadius: 1, // Blur of the shadow
                              offset: Offset(0, 3), // Position of the shadow (x, y)
                            ),
                          ],
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
