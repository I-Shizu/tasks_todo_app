import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_todo_app/auth_state_notifier.dart';
import 'package:tasks_todo_app/firebase_repository.dart';

import 'add_task_screen.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateNotifierProvider);
    
    //ユーザーがサインインしている場合はタスクリストを表示
    return authAsync.when(
      data: (user) {
        //userの取得が完了してからuserのタスクリストを取得
        final tasksAsync = ref.watch(userTasksProvider(user!.uid));
        final firebaseRepository = ref.read(firebaseRepositoryProvider);

        return Scaffold(
          appBar: AppBar(
            title: const Text('タスクリスト'),
          ),
          body: tasksAsync.when(
            data: (tasks) {
              if (tasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: 0.5,
                        duration: const Duration(milliseconds: 300),
                        child: Image.asset(
                          'assets/images/add_task_image.png',
                          width: 200,
                          height: 200,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: '新しいタスクを追加しよう',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTaskScreen(),
                                ),
                              );
                            },
                          )
                        ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Dismissible(
                    key: Key(task.id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      firebaseRepository.deleteTask(user.uid, task.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${task.title}を削除しました')),
                      );
                    },
                    child: ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.deadline.toIso8601String()),
                      trailing: Checkbox(
                        //チェックをつける
                        value: task.completed,
                        onChanged: (value) {
                          firebaseRepository.updateTask(
                            user.uid,
                            task.id,
                            {'completed': value},
                          );
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(
                              task: task,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('エラーが発生しました: $error')),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('エラーが発生しました: $error')),
    );
  }
}