import 'package:flutter/material.dart';

class AddBoardButton extends StatelessWidget {
  final Color statusColor;
  final VoidCallback onPressed;

  const AddBoardButton({
    Key? key,
    required this.statusColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.add, size: 16, color: statusColor),
        label: Text(
          "Tambah", 
          style: TextStyle(color: statusColor)
        ),
        style: TextButton.styleFrom(
          backgroundColor: statusColor.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
