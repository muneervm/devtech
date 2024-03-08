
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolistapp/modelclass.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  late Box<Task> taskBox;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box<Task>('tasks');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 15, 175, 66),
        title: Center(
          child: Text(
            'To-Do List',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Task Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller: dueDateController,
                    decoration: InputDecoration(
                      hintText: 'Due Date (DD-MM-YYYY)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _addTask();
                  },
                  child: Text('Add Task'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Box<Task>>(
              valueListenable: taskBox.listenable(),
              builder: (context, box, _) {
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    Task task = box.getAt(index)!;
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text('Due Date: ${task.dueDate.toString()}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editTask(task);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteTask(task);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addTask() {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        _isValidDateFormat(dueDateController.text)) {
      taskBox.add(Task(
        title: titleController.text,
        description: descriptionController.text,
        dueDate: dueDateController.text,
      ));
      _clearTextControllers();
    } else {
      _showInvalidInputMessage();
    }
  }

  void _editTask(Task task) {
    TextEditingController editTitleController =
        TextEditingController(text: task.title);
    TextEditingController editDescriptionController =
        TextEditingController(text: task.description);
    TextEditingController editDueDateController =
        TextEditingController(text: task.dueDate.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editTitleController,
                decoration: InputDecoration(
                  hintText: 'Task Title',
                ),
              ),
              TextField(
                controller: editDescriptionController,
                decoration: InputDecoration(
                  hintText: 'Description',
                ),
              ),
              TextField(
                controller: editDueDateController,
                decoration: InputDecoration(
                  hintText: 'Due Date (DD-MM-YYYY)',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (editTitleController.text.isNotEmpty &&
                    editDescriptionController.text.isNotEmpty &&
                    _isValidDateFormat(editDueDateController.text)) {
                  task.title = editTitleController.text;
                  task.description = editDescriptionController.text;
                  task.dueDate = editDueDateController.text;

                  task.save();

                  Navigator.pop(context);
                } else {
                  _showInvalidInputMessage();
                }
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                task.delete(); 
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  bool _isValidDateFormat(String input) {
    final RegExp dateRegex = RegExp(
      r'^\d{2}-\d{2}-\d{4}$',
    );
    return dateRegex.hasMatch(input);
  }

  void _showInvalidInputMessage() {
    print('Invalid input. Please fill in all fields and use a valid date format (DD-MM-YYYY).');
  }

  void _clearTextControllers() {
    titleController.clear();
    descriptionController.clear();
    dueDateController.clear();
  }
}
