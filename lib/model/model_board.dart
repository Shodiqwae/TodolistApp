class Board {
  final int? id;
  final String title;
  final String? description;
  final int? statusId;
  final int? titleBoardId;
  final int? tasksId;
  final DateTime? dueDate;
  final DateTime? doneDate; // ✅ Tambahkan ini
  final String? taskName;
  

  Board({
    this.id,
    required this.title,
    this.description,
    this.statusId,
    this.titleBoardId,
    this.tasksId,
    this.dueDate,
    this.doneDate, // ✅
    this.taskName,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      statusId: json['status_id'],
      titleBoardId: json['title_board_id'],
      tasksId: json['tasks_id'],
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      doneDate: json['done_date'] != null ? DateTime.parse(json['done_date']) : null, // ✅
      taskName: json['task']?['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status_id': statusId,
      'title_board_id': titleBoardId,
      'tasks_id': tasksId,
      'due_date': dueDate?.toIso8601String(),
      'done_date': doneDate?.toIso8601String(), // ✅
    };
  }
}
