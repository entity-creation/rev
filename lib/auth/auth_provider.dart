import 'package:rev/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<void> initialize();

  Future<AuthUser> login(
    String email,
    String password,
  );

  Future<void> logout();

  Future<AuthUser> register(
    String email,
    String password,
  );

  Future<void> deleteUser();

  Future<void> emailVerification();
}
