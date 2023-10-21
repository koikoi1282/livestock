import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {
  Stream<User?> get userStream => FirebaseAuth.instance.authStateChanges();

  Future<String?> login(String emailAddress, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return '找不到該帳號。';
      } else if (e.code == 'wrong-password') {
        return '密碼錯誤。';
      }

      return '發生錯誤，請重試。';
    }
  }
}
