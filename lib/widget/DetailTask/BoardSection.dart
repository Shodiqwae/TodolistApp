import 'package:flutter/material.dart';
import 'package:todolist_app/model/model_board.dart';
import 'package:todolist_app/model/status_model.dart';
import 'package:todolist_app/widget/DetailTask/AddBoardButton.dart';
import 'package:todolist_app/widget/DetailTask/StatusLabel.dart';

import 'BoardCard.dart';

class BoardsSection extends StatelessWidget {
  final List<Status> statusList;
  final Map<String, List<Board>> boardsByStatus;
  final Color Function(String) getStatusColor;
  final String Function(String) getDisplayLabel;
  final Function(Board) onBoardTap;
  final Function(String) onAddBoard;

  const BoardsSection({
    Key? key,
    required this.statusList,
    required this.boardsByStatus,
    required this.getStatusColor,
    required this.getDisplayLabel,
    required this.onBoardTap,
    required this.onAddBoard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: statusList.map((status) {
          final boardsInStatus = boardsByStatus[status.name] ?? [];
          final statusColor = getStatusColor(status.name);
          
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    
                    children: [
                      StatusLabel(
                        label: getDisplayLabel(status.name),
                        color: statusColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ...boardsInStatus.map<Widget>((board) {
                    return BoardCard(
                      board: board,
                      statusColor: statusColor,
                      onTap: () => onBoardTap(board),
                    );
                  }).toList(),
                  AddBoardButton(
                    statusColor: statusColor,
                    onPressed: () => onAddBoard(status.name),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}