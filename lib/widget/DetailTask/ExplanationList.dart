import 'package:flutter/material.dart';
import 'package:todolist_app/model/ExplanationModel.dart';

import 'ExplanationItem.dart';

class ExplanationsList extends StatelessWidget {
  final List<Explanation> explanations;
  final int? editingId;
  final TextEditingController editingNameController;
  final TextEditingController editingDeskripsiController;
  final Function(Explanation) onTap;
  final Function(Explanation) onSave;

  const ExplanationsList({
    Key? key,
    required this.explanations,
    required this.editingId,
    required this.editingNameController,
    required this.editingDeskripsiController,
    required this.onTap,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: explanations.length,
      itemBuilder: (context, index) {
        final item = explanations[index];
        final isEditing = editingId == item.id;

        return ExplanationItem(
          explanation: item,
          isEditing: isEditing,
          nameController: editingNameController,
          descriptionController: editingDeskripsiController,
          onTap: () => onTap(item),
          onSave: () => onSave(item),
        );
      },
    );
  }
}