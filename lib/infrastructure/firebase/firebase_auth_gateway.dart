import 'package:firebase_auth/firebase_auth.dart';

import '../../core/auth/auth_gateway.dart';

final class FirebaseAuthGateway implements AuthGateway {
  FirebaseAuthGateway(this._auth);

  final FirebaseAuth _auth;

  @override
  Stream<AuthUser?> get authStateChanges => _auth.authStateChanges().map(
    (user) =>
        user == null ? null : AuthUser(id: user.uid, email: user.email ?? ''),
  );

  @override
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('Firebase returned no authenticated user.');
    }
    return AuthUser(id: user.uid, email: user.email ?? email);
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
