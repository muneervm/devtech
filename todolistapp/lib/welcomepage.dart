
import 'package:flutter/material.dart';
import 'package:todolistapp/todolist.dart';

class Welcomepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to M-To Do List',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ToDoList(),
                  ),
                );
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
