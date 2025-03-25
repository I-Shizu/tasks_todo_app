import 'package:flutter/material.dart';
import 'package:tasks_todo_app/auth_sign_in.dart';

import 'home_page.dart';

//メールとパスワードでログインする画面
class MailLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('メールアドレスとパスワードでログイン'),
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'メールアドレス',
                suffixIcon: Icon(Icons.mail),
              ),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'パスワード',
                suffixIcon: Icon(Icons.lock),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;

                AuthService().signInWithEmailAndPassword(email, password);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('ログイン'),
            ),
          ],
        ),
      ),
    );
  }
}