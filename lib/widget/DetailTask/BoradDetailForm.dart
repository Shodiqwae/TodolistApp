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

  List<Status> getAvailableStatuses(String currentStatus) {
    switch (currentStatus) {
      case 'pending':
        return statusList.where((s) => s.name == 'pending' || s.name == 'in_progress').toList();
      case 'in_progress':
        return statusList.where((s) => s.name == 'in_progress' || s.name == 'done').toList();
      case 'done':
        return statusList.where((s) => s.name == 'done').toList();
      default:
        return statusList;
    }
  }

  @override
  Widget build(BuildContext context) {
final currentStatus = statusList.firstWhere(
  (status) => status.id == board.statusId,
  orElse: () => Status(id: 1, name: 'pending', color: 'gray'),
).name;
    final availableStatuses = getAvailableStatuses(currentStatus);
    final isDone = currentStatus == 'done';

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
              items: availableStatuses.map((status) {
                return DropdownMenuItem<String>(
                  value: status.name,
                  child: Text(getDisplayLabel(status.name)),
                );
              }).toList(),
              onChanged: isDone
                  ? null // disable jika status sudah 'done'
                  : (value) {
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
