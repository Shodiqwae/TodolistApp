import 'package:flutter/material.dart';
import 'package:todolist_app/model/ExplanationModel.dart';

class ExplanationItem extends StatelessWidget {
  final Explanation explanation;
  final bool isEditing;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const ExplanationItem({
    Key? key,
    required this.explanation,
    required this.isEditing,
    required this.nameController,
    required this.descriptionController,
    required this.onTap,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isEditing
                ? TextField(
                    controller: nameController,
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
                    onEditingComplete: onSave,
                  )
                : Text(
                    explanation.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            SizedBox(height: 4),
            isEditing
                ? TextField(
                    controller: descriptionController,
                    focusNode: FocusNode(),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    onEditingComplete: onSave,
                  )
                : Text(
                    explanation.deskripsi ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}