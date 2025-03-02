import 'package:flutter/material.dart';
import 'package:tasks_todo_app/UI/home_page.dart';

import '../Data/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TaskRepository taskRepository = TaskRepository();
  DateTime? deadline;
  int priority = 1;
  int estimatedTime = 0;
  int mendokusasa = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              items: [1, 2, 3]
                  .map((e) => DropdownMenuItem(value: e, child: Text('重要度 $e')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  priority = value!;
                });
              },
            ),
            SizedBox(height: 20),
            //推定所用時間の入力欄を追加
            TextField(
              decoration: InputDecoration(labelText: '推定所用時間'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                //入力された値を整数に変換してestimatedTimeに代入
                //変換できない場合は0を代入
                setState(() {
                  estimatedTime = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 20),
            //面倒さを選択するドロップダウンを追加
            DropdownButton<int>(
              value: mendokusasa,
              items: [1, 2, 3]
                  .map((e) => DropdownMenuItem(value: e, child: Text('面倒さ $e')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  mendokusasa = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                taskRepository.addTask(
                  Task(
                    id: '',
                    title: titleController.text,
                    deadline: deadline ?? DateTime.now(),
                    priority: priority,
                    estimatedTime: estimatedTime,
                    mendokusasa: mendokusasa,
                  ),
                );
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (context) => HomePage()), 
                  (route) => false
                );
              },
              child: Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}