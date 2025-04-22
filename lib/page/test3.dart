import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: TaskEditorPage()));
}

enum BlockType { text, board, table }

class TaskBlock {
  BlockType type;
  dynamic content;
  TaskBlock({required this.type, this.content});
}

class TaskEditorPage extends StatefulWidget {
  @override
  _TaskEditorPageState createState() => _TaskEditorPageState();
}

class _TaskEditorPageState extends State<TaskEditorPage> {
  List<TaskBlock> taskBlocks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Editor"),
        actions: [
          PopupMenuButton<BlockType>(
            icon: Icon(Icons.add),
            itemBuilder: (context) => [
              PopupMenuItem(value: BlockType.text, child: Text("Teks")),
              PopupMenuItem(value: BlockType.board, child: Text("Board View")),
              PopupMenuItem(value: BlockType.table, child: Text("Tabel")),
            ],
            onSelected: (value) {
              setState(() {
                taskBlocks.add(TaskBlock(type: value));
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: taskBlocks.map((block) => _buildBlock(block)).toList(),
        ),
      ),
    );
  }

  Widget _buildBlock(TaskBlock block) {
    switch (block.type) {
      case BlockType.text:
        return _buildTextBlock(block);
      case BlockType.board:
        return _buildBoardBlock(block);
      case BlockType.table:
        return _buildTableBlock(block);
    }
  }

  Widget _buildTextBlock(TaskBlock block) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        maxLines: null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Tulis teks di sini...",
        ),
        onChanged: (val) {
          block.content = val;
        },
      ),
    );
  }

  Widget _buildBoardBlock(TaskBlock block) {
    block.content ??= {
      "Not Started": [],
      "In Progress": [],
      "Done": [],
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ["Not Started", "In Progress", "Done"].map((status) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(status, style: TextStyle(fontWeight: FontWeight.bold)),
                  ...(block.content[status] as List).map<Widget>((item) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item),
                        ),
                      )),
                  TextButton(
                    onPressed: () {
                      block.content[status].add("Tugas baru");
                      setState(() {});
                    },
                    child: Text("+ Tambah"),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTableBlock(TaskBlock block) {
    block.content ??= [
      ["Judul", "Deadline"],
      ["Task 1", "20 Apr"],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Table(
        border: TableBorder.all(),
        children: (block.content as List<List<String>>)
            .map<TableRow>((row) => TableRow(
                  children: row
                      .map((cell) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(cell),
                          ))
                      .toList(),
                ))
            .toList(),
      ),
    );
  }
}
