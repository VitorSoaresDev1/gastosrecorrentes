import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  Future createUser({required String email, required String password}) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future signIn({required String email, required String password}) async {
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future resetPassword({required String email}) async {
    return await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  User? currentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
