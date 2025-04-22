import 'package:flutter/material.dart';

class TaskHeader extends StatelessWidget {
  final String name;
  final String priority;
  final VoidCallback onAdd;
  final VoidCallback onBack;
  final Color Function(String) getPriorityColor;

  const TaskHeader({
    Key? key,
    required this.name,
    required this.priority,
    required this.onAdd,
    required this.onBack,
    required this.getPriorityColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(19, 86, 148, 1),
            Color.fromRGBO(0, 102, 204, 1),
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
              Container(
                width: 250,
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Mont-SemiBold",
                    fontSize: 20,
                  ),
                ),
              ),
              IconButton(
                onPressed: onAdd,
                icon: Icon(Icons.add, color: Colors.white, size: 30),
              ),
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: getPriorityColor(priority),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
