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
  final bool isDone = board.statusId == 3;
  final DateTime? dateToShow = isDone ? board.doneDate : board.dueDate;

  bool isOverdue(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(DateTime(now.year, now.month, now.day));
  }

  final bool overdue = !isDone && dateToShow != null && isOverdue(dateToShow);

  return Card(
    elevation: 2,
    margin: EdgeInsets.only(bottom: 10),
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
                fontFamily: "Mont-SemiBold",
              ),
            ),
            if (dateToShow != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isDone
                          ? 'Selesai: ${dateToShow.day}-${dateToShow.month}-${dateToShow.year}'
                          : 'Due: ${dateToShow.day}-${dateToShow.month}-${dateToShow.year}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDone
                            ? Colors.green
                            : overdue
                                ? Colors.red
                                : isDueToday(dateToShow)
                                    ? const Color.fromARGB(255, 226, 24, 10)
                                    : Colors.grey[700],
                        fontFamily: "Mont-SemiBold",
                      ),
                    ),
                    if (overdue)
                      Text(
                        'Lewat tenggat waktu',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.redAccent,
                          fontFamily: "Mont-SemiBold",
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
  );
}


}
