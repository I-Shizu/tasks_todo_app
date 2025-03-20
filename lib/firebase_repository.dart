import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final FirebaseRepositoryProvider = Provider((ref) => FirebaseRepository());