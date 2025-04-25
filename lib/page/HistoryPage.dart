import 'package:bottom_bar_matu/bottom_bar/bottom_bar_bubble.dart';
import 'package:bottom_bar_matu/bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist_app/model/model_board.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todolist_app/page/CalenderPage.dart';
import 'package:todolist_app/page/Home.dart';
import 'package:todolist_app/page/Task.dart';

class Historypage extends StatefulWidget {
  final String token;

  const Historypage({super.key, required this.token});

  @override
  State<Historypage> createState() => _HistorypageState();
}

class _HistorypageState extends State<Historypage> {
  late List<Board> boards;
  Set<int> selectedCards = {};
  bool selectionMode = false;
  late String _token;
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _token = widget.token;
    loadData();
  }

  Future<List<Board>> getDoneBoard() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/done-board"),
        headers: {
          'Authorization': 'Bearer $_token',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((item) => Board.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to load data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in getDoneBoard: $e');
      throw Exception('Failed to load data: $e');
    }
  }

  // Fungsi untuk menghapus semua data board yang selesai

  // Fungsi untuk menghapus task tertentu
  Future<void> deleteboard(int taskId) async {
    final response = await http.delete(
      Uri.parse("http://10.0.2.2:8000/api/delete-board/$taskId"),
      headers: {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json',
      },
    );
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
            MaterialPageRoute(
                builder: (context) => HomePage(
                      token: _token,
                    )),
          );
        });
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
        // Future.delayed(Duration(milliseconds: 750), () {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => Historypage()),
        //   );
        // });
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

  bool isLoading = true;

  Future<void> loadData() async {
    try {
      final data = await getDoneBoard();
      setState(() {
        boards = data;
        isLoading = false;
      });
    } catch (e) {
      print("Gagal load data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 90,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromRGBO(19, 86, 148, 1),
              Color.fromRGBO(0, 102, 204, 1)
            ])),
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
                    Row(
                      children: [
                        if (selectionMode && selectedCards.isNotEmpty) ...[
                          // Menambahkan kondisi untuk hanya menampilkan "Pilih Semua" jika dalam mode seleksi

                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedCards = Set<int>.from(
                                    List.generate(boards.length, (i) => i));
                              });
                            },
                            child: Text("Pilih Semua",
                                style: TextStyle(color: Colors.white)),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
                            onPressed: () {
                              _showDeleteConfirmationDialog(() async {
                                for (int index in selectedCards.toList()
                                  ..sort((a, b) => b.compareTo(a))) {
                                  final board = boards[index];
                                  await deleteboard(
                                      int.parse(board.id.toString()));
                                  boards.removeAt(index);
                                }
                                selectedCards.clear();
                                selectionMode = false;
                                setState(() {});
                              });
                            },
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : boards.isEmpty
                  ? Center(child: Text("Data Done kosong"))
                  : Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final board = boards[index];
                                return GestureDetector(
                                    onTap: () {
                                      if (selectionMode) {
                                        setState(() {
                                          if (selectedCards.contains(index)) {
                                            selectedCards.remove(index);
                                            if (selectedCards.isEmpty) {
                                              selectionMode = false;
                                            }
                                          } else {
                                            selectedCards.add(index);
                                          }
                                        });
                                      } else {
                                        // bisa arahkan ke detail board atau fungsi lainnya
                                      }
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        selectionMode = true;
                                        selectedCards.add(index);
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 0),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Menambahkan atau menghapus index ke dalam selectedCards
                                          setState(() {
                                            if (selectedCards.contains(index)) {
                                              selectedCards.remove(index);
                                            } else {
                                              selectedCards.add(index);
                                            }
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 10),
                                          width: 305,
                                          height: 110,
                                          decoration: BoxDecoration(
                                            color: selectedCards.contains(index)
                                                ? const Color.fromARGB(
                                                    255, 180, 220, 255)
                                                : Colors.white,
                                            border:
                                                selectedCards.contains(index)
                                                    ? Border.all(
                                                        color: Colors.blue,
                                                        width: 4)
                                                    : Border.all(width: 0),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: selectedCards
                                                    .contains(index)
                                                ? [BoxShadow()]
                                                : [
                                                    BoxShadow(
                                                      color: const Color
                                                              .fromARGB(
                                                              255, 108, 16, 16)
                                                          .withOpacity(
                                                              0.1), // warna bayangan dengan transparansi
                                                      spreadRadius:
                                                          2, // seberapa jauh bayangan menyebar
                                                      blurRadius:
                                                          1, // seberapa blur bayangannya
                                                      offset: Offset(0,
                                                          3), // posisi bayangan (x, y)
                                                    ),
                                                  ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          left: 15),
                                                      child: Text(board.title,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 17,
                                                              fontFamily:
                                                                  "Mont-SemiBold"))),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          right: 20),
                                                      child: Text(
                                                          board.statusId == 3
                                                              ? "Done"
                                                              : "Belum Selesai",
                                                          style: TextStyle(
                                                              color: board.statusId ==
                                                                      3
                                                                  ? Color.fromARGB(
                                                                      255,
                                                                      41,
                                                                      83,
                                                                      20)
                                                                  : const Color
                                                                      .fromARGB(
                                                                      49,
                                                                      206,
                                                                      59,
                                                                      1),
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  "Mont-SemiBold"))),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                child: Text(
                                                    board.description ?? "-",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 129, 129, 129),
                                                        fontSize: 13,
                                                        fontFamily:
                                                            "Mont-SemiBold")),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15, bottom: 0),
                                                    child: Text(
                                                      board.doneDate != null
                                                          ? "Compeled: ${DateFormat('dd-MM-yyyy').format(board.doneDate!)}"
                                                          : "No due date",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 70, 143, 33),
                                                          fontSize: 15,
                                                          fontFamily:
                                                              "Mont-SemiBold"),
                                                    ),
                                                  ),
                                                  // Icon check_circle ketika container diseleksi
                                                  if (selectedCards
                                                      .contains(index))
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 15),
                                                      child: Icon(
                                                        Icons.check_circle,
                                                        color: Colors.blue,
                                                        size: 24,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              },
                              childCount: boards.length,
                            ),
                          ),
                        ],
                      ),
                    )
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
