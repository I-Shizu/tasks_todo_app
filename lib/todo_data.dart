import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  DateTime deadline;
  int priority;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.deadline,
    required this.priority,
    this.completed = false,
  });

  // Firestore用の変換メソッド
  factory Task.fromDocument(DocumentSnapshot doc) {
    return Task(
      id: doc.id,
      title: doc['title'],
      deadline: (doc['deadline'] as Timestamp).toDate(),
      priority: doc['priority'],
      completed: doc['completed'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'deadline': Timestamp.fromDate(deadline),
      'priority': priority,
      'completed': completed,
    };
  }

  // タスクのコピーを作成するメソッド
  Task copyWith({
    String? title,
    DateTime? deadline,
    int? priority,
    bool? completed,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
    );
  }
}