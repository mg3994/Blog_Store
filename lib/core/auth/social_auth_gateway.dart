import '../../features/auth/domain/entities/auth_user.dart';

abstract interface class SocialAuthGateway {
  Future<AuthUser?> signInWithGoogle();
}
