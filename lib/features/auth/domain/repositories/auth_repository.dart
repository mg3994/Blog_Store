import '../entities/auth_user.dart';

abstract interface class AuthRepository {
  Stream<AuthUser?> get authStateChanges;

  Future<AuthUser?> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
