import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: TaskDynamicPage()));

class TaskDynamicPage extends StatefulWidget {
  @override
  _TaskDynamicPageState createState() => _TaskDynamicPageState();
}

class _TaskDynamicPageState extends State<TaskDynamicPage> {
  List<Map<String, dynamic>> components = [];

void addComponent(String type) {
  setState(() {
    if (type == 'text') {
      components.add({
        'type': 'text',
        'data': '',
        'controller': TextEditingController()
      });
    } else if (type == 'board') {
      components.add({
        'type': 'board',
        'data': {
          'Not Started': [],
          'In Progress': [],
          'Done': [],
        }
      });
    } else if (type == 'table') {
      components.add({
        'type': 'table',
        'columns': [
          {'name': 'Title', 'type': 'text'}
        ],
        'rows': []
      });
    }
  });
}


Widget buildComponent(Map<String, dynamic> component, int index) {
  switch (component['type']) {
    case 'text':
  // Ambil controller
  TextEditingController controller = component['controller'];

  // Sinkronkan data hanya jika tidak sama
  if (controller.text != component['data']) {
    controller.text = component['data'];
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      controller: controller,
      maxLines: null,
      decoration: InputDecoration(
        hintText: "Enter text...",
        border: InputBorder.none, // Tanpa border
      ),
      onChanged: (val) {
        component['data'] = val;
      },
    ),
  );


    case 'board':
      return buildBoard(component['data']);
    case 'table':
      return buildTable(component);
    default:
      return Text('Unknown component');
  }
}


Widget buildBoard(Map<String, List<dynamic>> boardData) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: boardData.keys.map((status) {
        return Expanded(
          child: Column(
            children: [
              Text(status, style: TextStyle(fontWeight: FontWeight.bold)),
              ...boardData[status]!.map((task) => Card(
                    child: ListTile(title: Text(task.toString())),
                  )),
              TextButton(
                onPressed: () {
                  setState(() {
                    boardData[status]!.add('New Task');
                  });
                },
                child: Text('Add Task'),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}


  Widget buildTable(Map<String, dynamic> tableData) {
    List columns = tableData['columns'];
    List rows = tableData['rows'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Row(
            children: columns
                .map<Widget>((col) => Container(
                      width: 150,
                      padding: EdgeInsets.all(8),
                      child: Text('${col['name']} (${col['type']})'),
                    ))
                .toList(),
          ),
          ...rows.map<Widget>((row) {
            return Row(
              children: columns.map<Widget>((col) {
                return Container(
                  width: 150,
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    initialValue: row[col['name']] ?? '',
                    onChanged: (val) {
                      row[col['name']] = val;
                    },
                  ),
                );
              }).toList(),
            );
          }),
          Row(
            children: columns.map((col) {
              return Container(
                width: 150,
                padding: EdgeInsets.all(4),
                child: TextButton(
                    onPressed: () {
                      Map<String, dynamic> newRow = {};
                      for (var c in columns) {
                        newRow[c['name']] = '';
                      }
                      setState(() {
                        tableData['rows'].add(newRow);
                      });
                    },
                    child: Text('Add Row')),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void showAddMenu() {
    showModalBottomSheet(
        context: context,
        builder: (_) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.text_fields),
                  title: Text('Add Text'),
                  onTap: () {
                    Navigator.pop(context);
                    addComponent('text');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.table_chart),
                  title: Text('Add Table'),
                  onTap: () {
                    Navigator.pop(context);
                    addComponent('table');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.view_kanban),
                  title: Text('Add Board View'),
                  onTap: () {
                    Navigator.pop(context);
                    addComponent('board');
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Editor"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: showAddMenu,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: components.length,
        itemBuilder: (context, index) {
          return buildComponent(components[index], index);
        },
      ),
    );
  }
}
