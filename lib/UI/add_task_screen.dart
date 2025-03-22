import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_todo_app/UI/home_page.dart';
import '../Data/task.dart';
import '../auth_state_notifier.dart';
import '../firebase_repository.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final FirebaseRepository taskRepository = FirebaseRepository();
  DateTime? deadline;
  int priority = 1;
  int estimatedTime = 0;
  int mendokusasa = 1;

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authStateNotifierProvider);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'タイトル',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(deadline == null ? '締切を選ぶ' : "${deadline!.toLocal()}".split(' ')[0]),
                onTap: () async {
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
              ),
            ),
            SizedBox(height: 10),
            Text('重要度'),
            SegmentedButton<int>(
              segments: [
                ButtonSegment(value: 1, label: Text("低"), icon: Icon(Icons.low_priority)),
                ButtonSegment(value: 2, label: Text("中"), icon: Icon(Icons.priority_high)),
                ButtonSegment(value: 3, label: Text("高"), icon: Icon(Icons.warning)),
              ],
              selected: {priority},
              onSelectionChanged: (newSelection) {
                setState(() {
                  priority = newSelection.first;
                });
              },
            ),
            SizedBox(height: 20),
            Text('推定所要時間: $estimatedTime分'),
            Slider(
              value: estimatedTime.toDouble(),
              min: 0,
              max: 240,
              divisions: 24,
              label: estimatedTime.toString(),
              onChanged: (value) {
                setState(() {
                  estimatedTime = value.toInt();
                });
              },
            ),
            SizedBox(height: 20),
            Text('面倒さ'),
            SegmentedButton<int>(
              segments: [
                ButtonSegment(value: 1, label: Text("楽"), icon: Icon(Icons.sentiment_satisfied)),
                ButtonSegment(value: 2, label: Text("普通"), icon: Icon(Icons.sentiment_neutral)),
                ButtonSegment(value: 3, label: Text("面倒"), icon: Icon(Icons.sentiment_dissatisfied)),
              ],
              selected: {mendokusasa},
              onSelectionChanged: (newSelection) {
                setState(() {
                  mendokusasa = newSelection.first;
                });
              },
            ),
            SizedBox(height: 20),
            authAsync.when(
              data: (user) {
                if (user == null) {
                  return Column(
                    children: [
                      Text("ログインが必要です", style: TextStyle(color: Colors.red)),
                      ElevatedButton(
                        onPressed: null,
                        child: Text('保存'),
                      ),
                    ],
                  );
                }
                return Center(
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      taskRepository.createTask(
                        user.uid,
                        Task(
                          uid: user.uid,
                          id: '',
                          title: titleController.text,
                          deadline: deadline ?? DateTime.now(),
                          createdAt: DateTime.now().toIso8601String(),
                          priority: priority,
                          estimatedTime: estimatedTime,
                          mendokusasa: mendokusasa,
                          completed: false,
                        ).toFirestore(),
                      );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false,
                      );
                    },
                    label: Text('タスクを保存'),
                    icon: Icon(Icons.save),
                  ),
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Text("エラー: $e", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
