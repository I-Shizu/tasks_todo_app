import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasks_todo_app/UI/sign_in_screen.dart';
import 'package:tasks_todo_app/UI/task_list_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //スプラッシュ画面にするのもありだけどとりあえずはローディング表示
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          // ユーザーがサインイン済みの場合、ホーム画面へ遷移
          return TaskListScreen();
        }
        // サインインしていない場合、サインイン画面を表示
        return SignInScreen();
      },
    );
  }
}