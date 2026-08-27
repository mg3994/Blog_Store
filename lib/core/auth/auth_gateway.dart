abstract interface class AuthGateway {
  Stream<AuthUser?> get authStateChanges;

  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
}

final class AuthUser {
  const AuthUser({required this.id, required this.email});

  final String id;
  final String email;
}
