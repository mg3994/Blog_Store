import 'package:firebase_auth/firebase_auth.dart';

import '../../core/auth/auth_gateway.dart';
import '../../features/auth/domain/entities/auth_user.dart';

final class FirebaseAuthGateway implements AuthGateway {
  FirebaseAuthGateway(this._auth);

  final FirebaseAuth _auth;

  @override
  Stream<AuthUser?> get authStateChanges =>
      _auth.authStateChanges().map(_toAuthUser);

  @override
  Future<AuthUser?> signInWithEmail({
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
    return _toAuthUser(user);
  }

  @override
  Future<void> signOut() => _auth.signOut();

  AuthUser? _toAuthUser(User? user) {
    if (user == null) return null;
    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isEmailVerified: user.emailVerified,
    );
  }
}
