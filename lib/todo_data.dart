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
  factory Task.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Task(
      id: documentId,
      title: data['title'] ?? '',
      deadline: DateTime.parse(data['deadline'] ?? DateTime.now().toIso8601String()),
      priority: data['priority'] ?? 1,
      completed: data['completed'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'deadline': deadline.toIso8601String(),
      'priority': priority,
      'completed': completed,
    };
  }
}