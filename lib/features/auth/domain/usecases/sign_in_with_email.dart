import 'package:firebase_auth/firebase_auth.dart' show User;

import '../../../../core/auth/auth_gateway.dart';
import '../repositories/auth_repository.dart';

final class SignInWithEmail {
  const SignInWithEmail(this._repository);

  final AuthRepository _repository;

  Future<User?> call({required String email, required String password}) {
    return _repository.signInWithEmail(email: email, password: password);
  }
}
