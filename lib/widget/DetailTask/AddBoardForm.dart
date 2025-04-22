import 'package:flutter/material.dart';
import 'package:todolist_app/model/status_model.dart';

class AddBoardForm extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  final VoidCallback onSave;
  final VoidCallback onCancel;
  final DateTime? dueDate; // Menambahkan parameter dueDate
  final Function onDueDateSelected; // Menambahkan parameter onDueDateSelected

  const AddBoardForm({
    Key? key,
    required this.titleController,
    required this.descriptionController,
    required this.onSave,
    required this.onCancel,
    this.dueDate, // Menambahkan parameter dueDate
    required this.onDueDateSelected, // Menambahkan parameter onDueDateSelected
  }) : super(key: key);

  @override
  _AddBoardFormState createState() => _AddBoardFormState();
}

class _AddBoardFormState extends State<AddBoardForm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Tambah Board Baru"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widget.titleController,
              decoration: InputDecoration(
                labelText: "Judul",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: widget.descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Deskripsi (Opsional)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
 

            SizedBox(height: 12),
            // Due Date Picker
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.dueDate != null
                        ? 'Due Date: ${widget.dueDate!.day}-${widget.dueDate!.month}-${widget.dueDate!.year}'
                        : 'Pilih Due Date',
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    widget.onDueDateSelected(); // Memanggil fungsi dari widget utama
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text("Batal"),
        ),
        ElevatedButton(
          onPressed: widget.onSave,
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