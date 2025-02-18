//firestoreのパッケージをインポート
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks_todo_app/todo_data.dart';

//Taskクラスをを元にFiresroreのデータを取得、更新、削除するメソッドを持つクラス
class TaskRepository {
  //Firestoreのコレクション名
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
