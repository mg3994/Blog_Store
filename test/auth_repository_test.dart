import 'package:flutter_test/flutter_test.dart';

import 'package:blogstore/core/auth/auth_gateway.dart';
import 'package:blogstore/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blogstore/features/auth/domain/entities/auth_user.dart';
import 'package:blogstore/features/auth/domain/usecases/sign_in_with_email.dart';

void main() {
  group('SignInWithEmail and AuthRepositoryImpl', () {
    late FakeAuthGateway fakeGateway;
    late AuthRepositoryImpl repository;
    late SignInWithEmail useCase;

    const testUser = AuthUser(
      uid: 'user_123',
      email: 'test@example.com',
      displayName: 'Test User',
    );

    setUp(() {
      fakeGateway = FakeAuthGateway();
      repository = AuthRepositoryImpl(fakeGateway);
      useCase = SignInWithEmail(repository);
    });

    test('successfully signs in with email and password', () async {
      fakeGateway.userToReturn = testUser;

      final user = await useCase(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(user, isNotNull);
      expect(user?.uid, 'user_123');
      expect(user?.email, 'test@example.com');
      expect(fakeGateway.lastEmail, 'test@example.com');
      expect(fakeGateway.lastPassword, 'password123');
    });

    test('emits auth state changes from gateway', () async {
      fakeGateway.userStreamController = Stream.value(testUser);

      final user = await repository.authStateChanges.first;
      expect(user?.uid, 'user_123');
    });
  });
}

class FakeAuthGateway implements AuthGateway {
  AuthUser? userToReturn;
  String? lastEmail;
  String? lastPassword;
  Stream<AuthUser?> userStreamController = const Stream.empty();

  @override
  Stream<AuthUser?> get authStateChanges => userStreamController;

  @override
  Future<AuthUser?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    lastEmail = email;
    lastPassword = password;
    return userToReturn;
  }

  @override
  Future<void> signOut() async {}
}
