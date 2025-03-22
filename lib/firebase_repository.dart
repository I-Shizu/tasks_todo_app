import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Data/task.dart';

class FirebaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createTask(String userId, Map<String, dynamic> taskData) async {
    await _firestore.collection('users').doc(userId).collection('tasks').add(taskData);
  }

  Future<DocumentSnapshot> readTask(String userId, String taskId) async {
    return await _firestore.collection('users').doc(userId).collection('tasks').doc(taskId).get();
  }

  Future<void> updateTask(String userId, String taskId, Map<String, dynamic> taskData) async {
    await _firestore.collection('users').doc(userId).collection('tasks').doc(taskId).update(taskData);
  }

  Future<void> deleteTask(String userId, String taskId) async {
    await _firestore.collection('users').doc(userId).collection('tasks').doc(taskId).delete();
  }

  Stream<QuerySnapshot> getTasks(String userId) {
    return _firestore.collection('users').doc(userId).collection('tasks').snapshots();
  }
}

//FirebaseRepositoryを提供するProvider
final firebaseRepositoryProvider = Provider((ref) => FirebaseRepository());

//ユーザーIDを引数として受け取り、そのユーザータスクのStreamを取得するProvider
final userTasksProvider = StreamProvider.autoDispose.family<List<Task>, String>((ref, userId) {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('tasks')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return Task(
              uid: data['uid'],
              id: doc.id,
              title: data['title'] ?? '',
              deadline: (data['deadline'] as Timestamp).toDate(),
              createdAt: data['createdAt'] ?? '',
              priority: data['priority'] ?? 0,
              estimatedTime: data['estimatedTime'] ?? 0,
              mendokusasa: data['mendokusasa'] ?? 0,
              completed: data['completed'] ?? false,
            );
          }).toList());
});