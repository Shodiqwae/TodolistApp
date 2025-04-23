import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist_app/model/model_board.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todolist_app/page/Home.dart';
import 'package:todolist_app/page/Task.dart';

class Historypage extends StatefulWidget {
  const Historypage({super.key});

  @override
  State<Historypage> createState() => _HistorypageState();
}

class _HistorypageState extends State<Historypage> {
  int _currentIndex = 2;

  Future<List<Board>> getDoneBoard() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:8000/api/done-board"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Board.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Fungsi untuk menghapus semua data board yang selesai
  Future<void> deleteAllDoneBoards() async {
    final response = await http.delete(Uri.parse("http://10.0.2.2:8000/api/delete-done-boards"));
    if (response.statusCode == 200) {
      setState(() {});
    } else {
      throw Exception('Failed to delete boards');
    }
  }

  // Fungsi untuk menghapus task tertentu
Future<void> deleteTask(int taskId) async {
  final response = await http.delete(Uri.parse("http://10.0.2.2:8000/api/delete-board/$taskId"));
  if (response.statusCode == 200) {
    setState(() {});
  } else {
    throw Exception('Failed to delete task');
  }
}


  // Fungsi untuk menampilkan popup konfirmasi
  void _showDeleteConfirmationDialog(Function onDelete) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi Hapus"),
        content: Text("Apakah Anda yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            child: Text("Hapus"),
          ),
        ],
      ),
    );
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
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        });
        break;
      case 1:
        Future.delayed(Duration(milliseconds: 750), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TaskPage()),
          );
        });
        break;
      case 2:
        Future.delayed(Duration(milliseconds: 750), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Historypage()),
          );
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 90,
            decoration: BoxDecoration(color: Color.fromRGBO(27, 86, 253, 0.98)),
            child: Column(
              children: [
                SizedBox(height: 33),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 18),
                        child: Text("History Page",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Mont-SemiBold",
                                fontSize: 20))),
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        child: IconButton(
                            onPressed: () {
                              _showDeleteConfirmationDialog(deleteAllDoneBoards);
                            },
                            icon: Icon(
                              Icons.delete_forever_outlined,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              size: 33,
                            )))
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          FutureBuilder<List<Board>>(
            future: getDoneBoard(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("Data Done kosong"));
              }

              final boards = snapshot.data!;
              return Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final board = boards[index];
                          return GestureDetector(
                            onTap: () {
                              // Arahkan ke DetailBoard kalau kamu sudah buat
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              width: 385,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Text(board.title,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontFamily: "Mont-SemiBold"))),
                                      Container(
                                          margin: EdgeInsets.only(right: 20),
                                          child: Text(
                                              board.statusId == 3 ? "Done" : "Belum Selesai",
                                              style: TextStyle(
                                                  color: board.statusId == 3
                                                      ? Color.fromARGB(255, 89, 244, 12)
                                                      : const Color.fromARGB(49, 206, 59, 1),
                                                  fontSize: 16,
                                                  fontFamily: "Mont-SemiBold")))
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text(board.description ?? "-",
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 129, 129, 129),
                                            fontSize: 13,
                                            fontFamily: "Mont-SemiBold")),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 15,bottom: 0),
                                        child: Text(
                                          board.doneDate != null
                                              ? "Compeled: ${DateFormat('dd-MM-yyyy').format(board.doneDate!)}"
                                              : "No due date",
                                          style: TextStyle(
                                              color: Color.fromARGB(255, 95, 255, 42),
                                              fontSize: 15,
                                              fontFamily: "Mont-SemiBold"),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: IconButton(onPressed: () {}, icon: Icon(Icons.delete_forever,size: 30,color: Colors.red,)))
                                  // IconButton(
                                  //   icon: Icon(Icons.delete),
                                  //   onPressed: () {
                                  //     _showDeleteConfirmationDialog(() {
                                  // deleteTask(int.parse(board.id.toString()));                                        });
                                  //   },
                                  // )
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
          ),
        ],
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
          ),
          BottomBarItem(
            iconData: Icons.history,
          ),
          BottomBarItem(
            iconData: Icons.calendar_month,
          ),
        ],
        onSelect: _onNavTap,
        selectedIndex: _currentIndex,
      ),
    );
  }
}
