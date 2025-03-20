//userクラスを作成
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final DateTime? createdAt;
  final bool? isPremium;

  User({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL, 
    required this.createdAt, 
    required this.isPremium, 
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      photoURL: map['photoURL'],
      createdAt: map['createdAt'],
      isPremium: map['isPremium'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': createdAt,
      'isPremium': isPremium,
    };
  }

  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    DateTime? createdAt,
    bool? isPremium,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}

class UserRepository {
  final CollectionReference<Map<String, dynamic>> _collection 
    = FirebaseFirestore.instance.collection('users');

  //ユーザー情報を登録
  Future<void> addUser(User user) async {
    await _collection.doc(user.uid).set(user.toMap());
  }
  
  //ユーザー情報を取得
  Future<User?> getUser(String uid) async {
    final doc = await _collection.doc(uid).get();
    if (!doc.exists) {
      return null;
    }
    return User.fromMap(doc.data()!);
  }

  //ユーザー情報を更新
  Future<void> updateUser(User user) async {
    await _collection.doc(user.uid).set(user.toMap());
  }

  //ユーザー情報を削除
  Future<void> deleteUser(String uid) async {
    await _collection.doc(uid).delete();
  }
}