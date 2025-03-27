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

  //appleログイン
  Future<UserCredential> signInWithApple() async {
    if (Platform.isIOS) {
      // Appleのクレデンシャル取得
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      // OAuthクレデンシャル作成
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      // Firebaseでサインイン
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } else {
      throw UnsupportedError("Apple Sign-In is only supported on iOS");
    }
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