import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_todo_app/auth_state_notifier.dart';
import 'package:tasks_todo_app/firebase_repository.dart';

import '../Data/task.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProviderProvider);
    final authAsync = ref.watch(authStateNotifierProvider);
    final firebaseRepository = ref.read(FirebaseRepositoryProvider);

    //ユーザーがサインインしている場合はタスクリストを表示
    return authAsync.when(
      data: (user) {
        return Scaffold(
          body: tasksAsync.when(
            data: (tasks) {
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.deadline.toIso8601String()),
                    trailing: Checkbox(
                      value: task.completed,
                      onChanged: (value) {
                        firebaseRepository.updateTask(
                          user!.uid,
                          task.id,
                          task.copyWith(completed: value) as Map<String, dynamic>,
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