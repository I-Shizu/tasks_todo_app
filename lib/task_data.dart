import 'package:cloud_firestore/cloud_firestore.dart';

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