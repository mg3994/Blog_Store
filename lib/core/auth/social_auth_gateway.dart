import 'auth_gateway.dart';

abstract interface class SocialAuthGateway {
  Future<AuthUser?> signInWithGoogle();
}
