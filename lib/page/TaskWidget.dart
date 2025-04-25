import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  Future<void> deleteTask(int id) async {
  final response = await http.delete(
    Uri.parse('http://10.0.2.2:8000/api/tasks/$id'),
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

  List<Task> currentTasks = [];


  void confirmDelete(int id) {
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi"),
        content: Text("Yakin ingin menghapus task ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // batal
            child: Text("Tidak"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // tutup dialog
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
    return SingleChildScrollView(
      child: FutureBuilder<List<Task>>(
        future: widget.futuretasks, // Gunakan futuretasks yang dikirim dari HomePage
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks available.'));
          } else {
          currentTasks = snapshot.data!;
      
            return SizedBox(
              width: 370,
              height: 520,
              child: ListView.builder(
                itemCount: currentTasks.length,
                itemBuilder: (context, index) {
                  final task = currentTasks[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailTask(task: task)));
      
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 6,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 150,
                          width: 300,
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
                                        SizedBox(width: 8),
                                        // IconButton(
                                        //   icon: Icon(Icons.delete, color: Colors.red),
                                        //   onPressed: () => confirmDelete(task.id),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Priority: ${task.priority}",
                                  style: TextStyle(
                                    color: Color.fromRGBO(94, 92, 92, 1),
                                    fontSize: 12,
                                    fontFamily: "Mont-SemiBold",
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month_outlined,
                                        color: Color.fromRGBO(56, 48, 48, 1), size: 20),
                                    SizedBox(width: 6),
                                    Text(
                                      task.createdAt.split('T')[0],
                                      style: TextStyle(
                                        color: Color.fromRGBO(56, 48, 48, 1),
                                        fontFamily: "Mont-SemiBold",
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
              ),
            );
          }
        },
      ),
    );
  }
}
