import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth;

  AuthenticationService(this._auth);

  Stream<User?> get authStateChange => _auth.authStateChanges();


  // LOGIN — returns:"OK"                      → Login success
  // "ERROR: <message>"        → Login failed

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return "OK"; // login success flag

    } on FirebaseAuthException catch (e) {
      return "ERROR: ${e.message}";
    } catch (e) {
      return "ERROR: $e";
    }
  }

  // LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
