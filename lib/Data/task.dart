import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task.g.dart';

class Task {
  String id;
  String title;
  DateTime deadline;
  int priority;
  int estimatedTime;
  int mendokusasa = 0;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.deadline,
    required this.priority,
    required this.estimatedTime,
    required this.mendokusasa,
    this.completed = false,
  });

  // Firestore用の変換メソッド
  factory Task.fromDocument(DocumentSnapshot doc) {
    return Task(
      id: doc.id,
      title: doc['title'],
      deadline: (doc['deadline'] as Timestamp).toDate(),
      priority: doc['priority'],
      estimatedTime: doc['estimatedTime'],
      mendokusasa: doc['mendokusasa'],
      completed: doc['completed'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'deadline': Timestamp.fromDate(deadline),
      'priority': priority,
      'estimatedTime': estimatedTime,
      'mendokusasa': mendokusasa,
      'completed': completed,
    };
  }

  // タスクのコピーを作成するメソッド
  Task copyWith({
    String? title,
    DateTime? deadline,
    int? priority,
    int? estimatedTime,
    bool? completed,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      estimatedTime: this.estimatedTime,
      mendokusasa: this.mendokusasa,
      completed: completed ?? this.completed,
    );
  }
}

class TaskRepository {
  static const String collectionName = 'tasks';
  //Firestoreのコレクションの参照
  final CollectionReference<Map<String, dynamic>> _collection = FirebaseFirestore.instance.collection(collectionName);

  //Firestoreからデータを取得するStream型のメソッド
  Stream<List<Task>> getTasks() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromDocument(doc);
      }).toList();
    });
  }

  //Firestoreにデータを追加するメソッド
  Future<void> addTask(Task task) async {
    await _collection.add(task.toFirestore());
  }

  //Firestoreのデータを更新するメソッド
  Future<void> updateTask(Task task) async {
    return await _collection.doc(task.id).update(task.toFirestore());
  }

  //Firestoreのデータを削除するメソッド
  Future<void> deleteTask(Task task) async {
    await _collection.doc(task.id).delete();
  }
}

@riverpod
class TasksProvider extends _$TasksProvider {
  @override
  Stream<List<Task>> build() async* {
    await for (final tasks in TaskRepository().getTasks()) {
      yield tasks;
    }
  }
}