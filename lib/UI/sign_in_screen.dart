//ログインしたことがない場合の新規登録画面
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasks_todo_app/UI/home_page.dart';
import 'package:tasks_todo_app/auth_sign_in.dart';

import 'mail_login_screen.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(title: const Text('新規登録')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                // メールアドレスとパスワードでサインインする画面に遷移
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MailLoginScreen()),
                );
              },
              child: const Text('メール/パスワードでサインイン'),
            ),
            ElevatedButton(
              onPressed: () async {
                final User? user = await AuthService().signInWithGoogle();
                if (user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }
              },
              child: const Text('Googleアカウントでサインイン'),
            ),
            ElevatedButton(
              onPressed: () async {
                final User? user = await AuthService().signInWithApple();
                if (user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }
              },
              child: const Text('Appleアカウントでサインイン'),
            ),
          ],
        ),
      ),
    );
  }
}