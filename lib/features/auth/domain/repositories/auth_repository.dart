import 'package:firebase_auth/firebase_auth.dart' show User;


abstract interface class AuthRepository {
  Stream<User?> get authStateChanges;

  Future<User?> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
