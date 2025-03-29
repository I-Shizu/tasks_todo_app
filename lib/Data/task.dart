import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String uid;
  String id;
  String title;
  DateTime deadline;
  String createdAt;
  int priority;
  int estimatedTime;
  int mendokusasa = 0;
  bool completed;

  Task({
    required this.uid,
    required this.id,
    required this.title,
    required this.deadline,
    required this.createdAt,
    required this.priority,
    required this.estimatedTime,
    required this.mendokusasa,
    this.completed = false,
  });

  // Firestore用の変換メソッド
  factory Task.fromDocument(DocumentSnapshot doc) {
    return Task(
      uid: doc['uid'],
      id: doc.id,
      title: doc['title'],
      deadline: (doc['deadline'] as Timestamp).toDate(),
      createdAt: doc['createdAt'],
      priority: doc['priority'],
      estimatedTime: doc['estimatedTime'],
      mendokusasa: doc['mendokusasa'],
      completed: doc['completed'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'id': id,
      'title': title,
      'deadline': Timestamp.fromDate(deadline),
      'createdAt': createdAt,
      'priority': priority,
      'estimatedTime': estimatedTime,
      'mendokusasa': mendokusasa,
      'completed': completed,
    };
  }

  // タスクのコピーを作成するメソッド
  Task copyWith({
    String? uid,
    String? id,
    String? title,
    DateTime? deadline,
    String? createdAt,
    int? priority,
    int? estimatedTime,
    bool? completed, 
    required int mendokusasa,
  }) {
    return Task(
      uid: uid ?? this.uid,
      id: id ?? this.id,
      title: title ?? this.title,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
      estimatedTime: this.estimatedTime,
      mendokusasa: mendokusasa,
      completed: completed ?? this.completed,
    );
  }
}