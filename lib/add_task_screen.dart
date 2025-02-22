import 'package:flutter/material.dart';

import '../firebase_repository.dart';
import '../todo_data.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskRepository taskRepository = TaskRepository();
  final TextEditingController titleController = TextEditingController();
  DateTime? deadline;
  int priority = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('タスク追加')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'タイトル'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    deadline = pickedDate;
                  });
                }
              },
              child: Text(deadline == null ? '締切を選ぶ' : deadline.toString()),
            ),
            SizedBox(height: 10),
            DropdownButton<int>(
              value: priority,
              items: [1, 2, 3, 4, 5]
                  .map((e) => DropdownMenuItem(value: e, child: Text('重要度 $e')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  priority = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                taskRepository.addTask(
                  Task(
                    id: '',
                    title: titleController.text,
                    deadline: deadline ?? DateTime.now(),
                    priority: priority,
                  ),
                );
                Navigator.pop(context);
              },
              child: Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}