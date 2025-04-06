import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Googleログイン
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  // 匿名ログイン
  Future<UserCredential> signInAnonymously() async {
    final UserCredential userCredential = await _auth.signInAnonymously();
    return userCredential;
  }

  //appleログイン
  Future<UserCredential> signInWithApple() async {
    if (Platform.isIOS) {
      try {
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
        if (appleCredential.identityToken == null) {
          print('Apple Sign-In failed: Missing credentials');
        }

        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );
        if (oauthCredential.accessToken == null) {
          print('Apple Sign-In failed: Missing access token');
          
        }

        return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      } catch (e) {
        print("Error during Apple Sign-In: $e");
        rethrow;  // エラーを再スローして上位でキャッチできるようにする
      }
    }
    throw Exception('Apple Sign-In is only supported on iOS devices');
  }

  //メールアドレスとパスワードでログイン
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // ログアウト
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 現在のユーザー取得
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //アカウント削除機能
  Future<void> deleteAccount() async {
    final User? user = _auth.currentUser;
    await user?.delete();
  }
}