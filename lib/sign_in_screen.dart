//ログイン画面後のグーグルサインイン画面を作成
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasks_todo_app/auth_sign_in.dart';
import 'package:tasks_todo_app/task_list_screen.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('サインイン')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final User? user = await AuthService().signInWithGoogle();
            if (user != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => TaskListScreen()),
              );
            }
          },
          child: const Text('Googleでサインイン'),
        ),
      ),
    );
  }
}