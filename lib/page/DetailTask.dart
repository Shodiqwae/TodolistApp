import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todolist_app/model/model_board.dart';
import 'package:todolist_app/model/status_model.dart';
import 'package:todolist_app/model/taskmodel.dart';
import 'package:todolist_app/model/explanationmodel.dart';
import 'package:todolist_app/widget/DetailTask/AddBoardForm.dart';
import 'package:todolist_app/widget/DetailTask/AddExplanationForm.dart';
import 'package:todolist_app/widget/DetailTask/BoardSection.dart';
import 'package:todolist_app/widget/DetailTask/BoradDetailForm.dart';
import 'package:todolist_app/widget/DetailTask/TaskHeader.dart';
import 'package:intl/intl.dart';


class DetailTask extends StatefulWidget {
  final Task task;

  const DetailTask({Key? key, required this.task}) : super(key: key);

  @override
  State<DetailTask> createState() => _DetailTaskState();
}

class _DetailTaskState extends State<DetailTask> {
  List<Explanation> explanations = [];
  List<Status> statusList = [];
  List<Board> boards = [];
  int? editingId;
  Map<String, List<Board>> boardsByStatus = {};
  bool isBoardAdded = false;
  String selectedStatus = '';
  String editBoardSelectedStatus = '';
  bool isLoading = false;
  DateTime? selectedDueDate;


  final String baseUrl = "http://10.0.2.2:8000/api";

  // Text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController editingNameController = TextEditingController();
  TextEditingController editingDeskripsiController = TextEditingController();
  TextEditingController boardTitleController = TextEditingController();
  TextEditingController boardDescriptionController = TextEditingController();
  TextEditingController boardEditTitleController = TextEditingController();
  TextEditingController boardEditDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchExplanations();
    fetchStatus();
  }

  // Fetch data methods
  Future<void> fetchStatus() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('$baseUrl/status'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final statuses = data.map((json) => Status.fromJson(json)).toList();

        setState(() {
          statusList = statuses;
          if (statusList.isNotEmpty) {
            selectedStatus = statusList[0].name;
          }
          
          // Initialize boardsByStatus with empty lists for each status
          for (var status in statusList) {
            boardsByStatus[status.name] = [];
          }
        });
        
        // Fetch boards after statuses are loaded
        fetchBoards();
      } else {
        print('Failed to fetch statuses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching statuses: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchBoards() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('$baseUrl/boards/task/${widget.task.id}'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Board> fetchedBoards = data.map((json) => Board.fromJson(json)).toList();

        setState(() {
          boards = fetchedBoards;
          
          // Reset boardsByStatus
          for (var status in statusList) {
            boardsByStatus[status.name] = [];
          }
          
          // Group boards by status
          for (var board in boards) {
            if (board.statusId != null) {
              final statusObj = statusList.firstWhere(
                (status) => status.id == board.statusId,
                orElse: () => statusList.first
              );
              
              String statusName = statusObj.name;
              
              if (boardsByStatus.containsKey(statusName)) {
                boardsByStatus[statusName]?.add(board);
              }
            }
          }
          
          isBoardAdded = boards.isNotEmpty;
        });
      } else {
        print('Failed to fetch boards: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching boards: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchExplanations() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('$baseUrl/explanations'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Explanation> filtered = data
            .map((json) => Explanation.fromJson(json))
            .where((e) => e.projectId == widget.task.id)
            .toList();

        setState(() => explanations = filtered);
      } else {
        print('Failed to fetch explanations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching explanations: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  // CRUD operations
  Future<void> addExplanation() async {
    final newName = nameController.text.trim();
    final newDesc = deskripsiController.text.trim();

    if (newName.isEmpty) return;

    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/explanations'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': newName,
          'deskripsi': newDesc,
          'project_id': widget.task.id,
        }),
      );

      if (response.statusCode == 201) {
        nameController.clear();
        deskripsiController.clear();
        Navigator.pop(context);
        fetchExplanations();
      } else {
        print('Failed to add explanation: ${response.statusCode}');
        print('Response body: ${response.body}');
        _showErrorDialog('Failed to add explanation');
      }
    } catch (e) {
      print('Error adding explanation: $e');
      _showErrorDialog('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _selectDueDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDueDate ?? DateTime.now(), // Default to today
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDueDate) {
      setState(() {
        selectedDueDate = pickedDate;
      });
    }
  }


  Future<void> addBoard() async {
    final title = boardTitleController.text.trim();
    final description = boardDescriptionController.text.trim();
    
    if (title.isEmpty) {
      _showErrorDialog('Title cannot be empty');
      return;
    }

    setState(() => isLoading = true);
    try {
      // Find the status ID from the selected status name
final selectedStatusObject = statusList.firstWhere(
  (status) => status.name == "pending",
  orElse: () => statusList.first,
);
final int statusId = selectedStatusObject.id ?? 1;

      
 final response = await http.post(
  Uri.parse('$baseUrl/boards'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'title': title,
    'description': description,
    'status_id': statusId,
    'tasks_id': widget.task.id,
    'due_date': selectedDueDate != null ? selectedDueDate!.toIso8601String() : null, // ✅ Pastikan validasi tanggal
  }),
);


      if (response.statusCode == 201) {
        Board newBoard;
        try {
          newBoard = Board.fromJson(jsonDecode(response.body));
        } catch (e) {
          print('Error parsing response: $e');
          // Create a new board with the entered values as fallback
          final newId = boards.isNotEmpty ? boards.map((b) => b.id ?? 0).reduce(max) + 1 : 1;
          
          newBoard = Board(
  id: newId,
  title: title,
  description: description,
  statusId: statusId,
  tasksId: widget.task.id,
  dueDate: selectedDueDate,
);

        }
        
        setState(() {
          boards.add(newBoard);
          boardsByStatus[selectedStatus]?.add(newBoard);
          isBoardAdded = true;
        });
        
        boardTitleController.clear();
        boardDescriptionController.clear();
        Navigator.pop(context);
        
        // Reload boards to ensure consistency
        fetchBoards();
      } else {
        _showErrorDialog('Failed to add board: ${response.body}');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> updateBoard(Board board) async {
    final title = boardEditTitleController.text.trim();
    final description = boardEditDescriptionController.text.trim();
    
    if (title.isEmpty) {
      _showErrorDialog('Title cannot be empty');
      return;
    }

    setState(() => isLoading = true);
    try {
      // Find the status ID from the selected status name
      final selectedStatusObject = statusList.firstWhere(
        (status) => status.name == editBoardSelectedStatus,
        orElse: () => statusList.first,
      );
      
      final int statusId = selectedStatusObject.id ?? board.statusId ?? 1;
      
      final response = await http.put(
        Uri.parse('$baseUrl/boards/${board.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'description': description,
          'status_id': statusId,
          'tasks_id': widget.task.id,
        }),
      );

      if (response.statusCode == 200) {
        Board updatedBoard;
        try {
          updatedBoard = Board.fromJson(jsonDecode(response.body));
        } catch (e) {
          updatedBoard = Board(
            id: board.id,
            title: title,
            description: description,
            statusId: statusId,
            tasksId: widget.task.id,
          );
        }
        
        setState(() {
          // Remove the old board from its previous status group
          if (board.statusId != null) {
            final oldStatusObj = statusList.firstWhere(
              (status) => status.id == board.statusId,
              orElse: () => statusList.first
            );
            
            final oldStatusName = oldStatusObj.name;
            boardsByStatus[oldStatusName]?.removeWhere((b) => b.id == board.id);
          }
          
          // Update the board in the boards list
          final index = boards.indexWhere((b) => b.id == board.id);
          if (index != -1) {
            boards[index] = updatedBoard;
          }
          
          // Add the board to its new status group
          boardsByStatus[editBoardSelectedStatus]?.add(updatedBoard);
        });
        
        Navigator.pop(context);
        
        // Reload boards to ensure consistency
        fetchBoards();
      } else {
        _showErrorDialog('Failed to update board');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> saveEditedExplanation(Explanation item) async {
    final updatedName = editingNameController.text.trim();
    final updatedDeskripsi = editingDeskripsiController.text.trim();

    if (updatedName.isEmpty) {
      _showErrorDialog('Title cannot be empty');
      return;
    }

    setState(() => isLoading = true);
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/explanations/${item.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': updatedName,
          'deskripsi': updatedDeskripsi,
          'project_id': widget.task.id,
        }),
      );

      if (response.statusCode == 200) {
        final updated = Explanation.fromJson(jsonDecode(response.body));
        setState(() {
          final index = explanations.indexWhere((e) => e.id == item.id);
          if (index != -1) {
            explanations[index] = updated;
          }
          editingId = null;
        });
      } else {
        _showErrorDialog('Failed to update explanation');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  // UI Helper methods
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void showOptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pilih Jenis Tambahan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.note_add),
              title: Text("Tambah Explanation"),
              onTap: () {
                Navigator.pop(context);
                _showAddExplanationDialog();
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard_customize),
              title: Text("Tambah Board"),
              onTap: () {
                Navigator.pop(context);
                showAddBoardDialog();
              },
            )
          ],
        ),
      ),
    );
  }

  void _showAddExplanationDialog() {
    showDialog(
      context: context,
      builder: (_) => AddExplanationForm(
        nameController: nameController,
        deskripsiController: deskripsiController,
        onSave: addExplanation,
        onCancel: () {
          nameController.clear();
          deskripsiController.clear();
          Navigator.pop(context);
        },
      ),
    );
  }

  void showAddBoardDialog() {
    // Make sure we have a default status selected
    if (selectedStatus.isEmpty && statusList.isNotEmpty) {
      selectedStatus = statusList[0].name;
    }
    
 showDialog(
  context: context,
  builder: (_) {
    return StatefulBuilder(
      builder: (context, setStateDialog) {
        return AddBoardForm(
          titleController: boardTitleController,
          descriptionController: boardDescriptionController,
          onSave: addBoard,
          onCancel: () {
            boardTitleController.clear();
            boardDescriptionController.clear();
            Navigator.pop(context);
          },
          dueDate: selectedDueDate,
          onDueDateSelected: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() => selectedDueDate = picked); // update di parent
              setStateDialog(() {}); // update di dalam dialog biar UI refresh
            }
          },
        );
      },
    );
  },
);

  }

  void showBoardDetailDialog(Board board) {
    boardEditTitleController.text = board.title;
    boardEditDescriptionController.text = board.description ?? '';
    
    // Find the status name from the status ID
    final statusObj = statusList.firstWhere(
      (status) => status.id == board.statusId,
      orElse: () => statusList.first
    );
    
    setState(() {
      editBoardSelectedStatus = statusObj.name;
    });
    
    showDialog(
      context: context,
      builder: (_) => BoardDetailForm(
        board: board,
        titleController: boardEditTitleController,
        descriptionController: boardEditDescriptionController,
        onStatusSelected: (status) {
          setState(() => editBoardSelectedStatus = status);
        },
        statusList: statusList,
        selectedStatus: editBoardSelectedStatus,
        onSave: () => updateBoard(board),
        onCancel: () {
          boardEditTitleController.clear();
          boardEditDescriptionController.clear();
          Navigator.pop(context);
        },
      ),
    );
  }

  // Utility methods
  Color getStatusColor(String statusName) {
    switch (statusName) {
      case 'pending': return Colors.orange;
      case 'in_progress': return Colors.blue;
      case 'done': return Colors.green;
      default: return Colors.grey;
    }
  }

  String getDisplayLabel(String statusName) {
    switch (statusName) {
      case 'pending': return 'Pending';
      case 'in_progress': return 'In Progress';
      case 'done': return 'Done';
      default: return statusName;
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high': return Colors.red;
      case 'medium': return Colors.orange;
      case 'low': return Colors.green;
      case 'urgent': return Colors.purple;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              TaskHeader(
                taskName: widget.task.name,
                priority: widget.task.priority,
                onAdd: showOptionDialog,
                onBack: () => Navigator.pop(context),
                getPriorityColor: getPriorityColor,
              ),
              const SizedBox(height: 10),
              if (isBoardAdded) 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BoardsSection(
                    statusList: statusList,
                    boardsByStatus: boardsByStatus,
                    getStatusColor: getStatusColor,
                    getDisplayLabel: getDisplayLabel,
                    onBoardTap: showBoardDetailDialog,
                    onAddBoard: (statusName) {
                      setState(() => selectedStatus = statusName);
                      showAddBoardDialog();
                    },
                  ),
                ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: explanations.length,
                  itemBuilder: (context, index) {
                    final item = explanations[index];
                    final isEditing = editingId == item.id;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          editingId = item.id;
                          editingNameController.text = item.name;
                          editingDeskripsiController.text = item.deskripsi ?? '';
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isEditing
                                ? TextField(
                                    controller: editingNameController,
                                    focusNode: FocusNode(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: InputBorder.none,
                                    ),
                                    onEditingComplete: () => saveEditedExplanation(item),
                                  )
                                : Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            SizedBox(height: 4),
                            isEditing
                                ? TextField(
                                    controller: editingDeskripsiController,
                                    focusNode: FocusNode(),
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: InputBorder.none,
                                    ),
                                    maxLines: null,
                                    onEditingComplete: () => saveEditedExplanation(item),
                                  )
                                : Text(
                                    item.deskripsi ?? '',
                                    style: TextStyle(fontSize: 16),
                                  ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}