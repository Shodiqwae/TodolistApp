import 'package:flutter/material.dart';
import 'package:todolist_app/model/model_board.dart';

class BoardCard extends StatelessWidget {
  final Board board;
  final Color statusColor;
  final VoidCallback onTap;

  const BoardCard({
    Key? key,
    required this.board,
    required this.statusColor,
    required this.onTap,
  }) : super(key: key);

  bool isDueToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year && date.month == now.month && date.day == now.day;
}


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: statusColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                board.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (board.dueDate != null)
  Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text(
      'Due: ${board.dueDate!.day}-${board.dueDate!.month}-${board.dueDate!.year}',
      style: TextStyle(
        fontSize: 12,
        color: isDueToday(board.dueDate!) ? Colors.red : Colors.grey[700],
      ),
    ),
  ),

            ],
          ),
        ),
      ),
    );
  }
}