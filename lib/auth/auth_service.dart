import 'package:rev/auth/auth_provider.dart';
import 'package:rev/auth/auth_user.dart';
import 'package:rev/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(
        FirebaseAuthProvider(),
      );
  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> deleteUser() => provider.deleteUser();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUser> login(String email, String password) => provider.login(
        email,
        password,
      );

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<AuthUser> register(String email, String password) => provider.register(
        email,
        password,
      );

  @override
  Future<void> emailVerification() => provider.emailVerification();
}
