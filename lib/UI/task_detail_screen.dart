import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_todo_app/Data/task.dart';
import 'package:tasks_todo_app/auth_state_notifier.dart';
import 'package:tasks_todo_app/firebase_repository.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  bool isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _estimatedTimeController;
  late TextEditingController _priorityController;
  late TextEditingController _mendokusasaController;
  late DateTime _selectedDueDate;

  @override
  void initState() {
    super.initState();
    // 既存のタスクデータで各フィールドを初期化
    _titleController = TextEditingController(text: widget.task.title);
    _estimatedTimeController = TextEditingController(text: widget.task.estimatedTime.toString());
    _priorityController = TextEditingController(text: widget.task.priority.toString());
    _mendokusasaController = TextEditingController(text: widget.task.mendokusasa.toString());
    _selectedDueDate = widget.task.deadline;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _estimatedTimeController.dispose();
    _priorityController.dispose();
    _mendokusasaController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDueDate = pickedDate;
      });
    }
  }

  void _saveChanges(String userId) {
    // 更新処理：Task オブジェクトを新しい値で置き換えて Firestore を更新する。
    final firebaseRepository = ref.read(firebaseRepositoryProvider);
    final updatedTask = widget.task.copyWith(
      title: _titleController.text,
      deadline: _selectedDueDate,
      estimatedTime: int.tryParse(_estimatedTimeController.text) ?? widget.task.estimatedTime,
      priority: int.tryParse(_priorityController.text) ?? widget.task.priority,
      mendokusasa: int.tryParse(_mendokusasaController.text) ?? widget.task.mendokusasa,
    );
    firebaseRepository.updateTask(
      userId,
      widget.task.id,
      updatedTask.toFirestore(),
    );
    setState(() {
      isEditing = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authStateNotifierProvider);
    
    return authAsync.when(
      data: (user) {
        if (user == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("タスクの詳細")),
            body: const Center(child: Text("ログインが必要です")),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(isEditing ? "タスク編集" : "タスクの詳細"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(isEditing ? Icons.check : Icons.edit),
                onPressed: () {
                  if (isEditing) {
                    _saveChanges(user.uid);
                  } else {
                    setState(() {
                      isEditing = true;
                    });
                  }
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // タイトルの表示/編集
                isEditing
                    ? TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'タイトル'),
                      )
                    : Text(
                        _titleController.text,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                const SizedBox(height: 16),
                // 締切日の表示/編集
                const Text('締切日:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                isEditing
                    ? Row(
                        children: [
                          Text(
                            "${_selectedDueDate.toLocal()}".split(' ')[0],
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _pickDueDate,
                            child: const Text('日付変更'),
                          ),
                        ],
                      )
                    : Text(
                        "${_selectedDueDate.toLocal()}".split(' ')[0],
                        style: const TextStyle(fontSize: 16),
                      ),
                const SizedBox(height: 16),
                // 推定所要時間の表示/編集
                isEditing
                    ? TextField(
                        controller: _estimatedTimeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: '推定所要時間 (分)'),
                      )
                    : Text(
                        '推定所要時間: ${_estimatedTimeController.text} 分',
                        style: const TextStyle(fontSize: 16),
                      ),
                const SizedBox(height: 16),
                // 重要度の表示/編集
                isEditing
                    ? TextField(
                        controller: _priorityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: '重要度'),
                      )
                    : Text(
                        '重要度: ${_priorityController.text}',
                        style: const TextStyle(fontSize: 16),
                      ),
                const SizedBox(height: 16),
                // めんどくささの表示/編集
                isEditing
                    ? TextField(
                        controller: _mendokusasaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'めんどくささ'),
                      )
                    : Text(
                        'めんどくささ: ${_mendokusasaController.text}',
                        style: const TextStyle(fontSize: 16),
                      ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(body: Center(child: Text("エラー: $error"))),
    );
  }
}