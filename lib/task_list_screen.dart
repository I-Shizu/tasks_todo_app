import 'package:flutter/material.dart';
import 'package:tasks_todo_app/add_task_screen.dart';

import '../firebase_repository.dart';
import '../todo_data.dart';

class TaskListScreen extends StatelessWidget {
  final TaskRepository taskRepository = TaskRepository();

  TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TODOリスト')),
      body: StreamBuilder<List<Task>>(
        stream: taskRepository.getTasks(),
        builder: (context, snapshot) {
          // データ取得中
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // エラーが発生した場合
          if (snapshot.hasError) {
            return Center(child: Text('エラーが発生しました: ${snapshot.error}'),);
          }
          // データが取得できた場合
          if (snapshot.hasData) {
            // データが空の場合の処理
            if (snapshot.data!.isEmpty) {
              return Center(child: Text('タスクがありません'));
            }
            // タスクがある場合の ListView
            var tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.deadline.toString()),
                  leading: Checkbox(
                    value: task.completed,
                    onChanged: (value) {
                      taskRepository.updateTask(task.copyWith(completed: value));
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => taskRepository.deleteTask(task),
                  ),
                );
              },
            );
          }
          // それ以外のケース
          return Center(child: Text('データがありません'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
      ),
    );
  }
}