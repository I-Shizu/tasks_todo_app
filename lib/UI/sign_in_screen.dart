//ログインしたことがない場合の新規登録画面

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';
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
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            SignInButton(
              Buttons.email,
              text: 'メールアドレスでログイン',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MailLoginScreen(),
                  ),
                );
              },
            ),
            SignInButton(
              Buttons.google,
              text: 'Googleでログイン',
              onPressed: () async {
                final User? user = await AuthService().signInWithGoogle();
                if (user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }
              },
            ),
            SignInButton(
              Buttons.apple,
              text: 'Appleでログイン',
              onPressed: () async {
                try {
                  await AuthService().signInWithApple();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('エラー'),
                      content: const Text('Appleでのログインに失敗しました。'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            //ログインせずにサインイン（匿名認証）
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                final UserCredential userCredential = await AuthService().signInAnonymously();
                if (userCredential.user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }
              },
              child: const Text('ログインせずに始める'),
            ),
          ],
        ),
      ),
    );
  }
}