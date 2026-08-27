import '../../../../core/auth/auth_gateway.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._gateway);

  final AuthGateway _gateway;

  @override
  Stream<AuthUser?> get authStateChanges => _gateway.authStateChanges;

  @override
  Future<AuthUser?> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _gateway.signInWithEmail(email: email, password: password);
  }

  @override
  Future<void> signOut() => _gateway.signOut();
}
