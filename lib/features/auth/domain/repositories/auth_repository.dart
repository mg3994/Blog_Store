import '../../../../core/auth/auth_gateway.dart';

abstract interface class AuthRepository {
  Stream<AuthUser?> get authStateChanges;

  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
