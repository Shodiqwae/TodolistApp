import 'package:flutter/material.dart';

class AddExplanationForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController deskripsiController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const AddExplanationForm({
    super.key,
    required this.nameController,
    required this.deskripsiController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tambah Explanation'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: deskripsiController,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: onSave,
          child: Text("Simpan"),
        ),
        TextButton(
          onPressed: onCancel,
          child: Text("Batal"),
        ),
      ],
    );
  }
}
