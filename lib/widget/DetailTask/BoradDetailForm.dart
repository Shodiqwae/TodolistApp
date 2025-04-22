import 'package:flutter/material.dart';
import 'package:todolist_app/model/model_board.dart';
import 'package:todolist_app/model/status_model.dart';

class BoardDetailForm extends StatelessWidget {
  final Board board;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final Function(String) onStatusSelected;
  final List<Status> statusList;
  final String selectedStatus;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const BoardDetailForm({
    Key? key,
    required this.board,
    required this.titleController,
    required this.descriptionController,
    required this.onStatusSelected,
    required this.statusList,
    required this.selectedStatus,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Detail Board"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Judul",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Deskripsi",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
              items: statusList.map((status) {
                return DropdownMenuItem<String>(
                  value: status.name,
                  child: Text(getDisplayLabel(status.name)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onStatusSelected(value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text("Batal"),
        ),
        ElevatedButton(
          onPressed: onSave,
          child: Text("Simpan"),
        ),
      ],
    );
  }

  String getDisplayLabel(String statusName) {
    switch (statusName) {
      case 'pending':
        return 'Pending';
      case 'in_progress':
        return 'In Progress';
      case 'done':
        return 'Done';
      default:
        return statusName;
    }
  }
}
