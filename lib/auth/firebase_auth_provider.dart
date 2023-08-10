import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rev/auth/auth_user.dart';
import 'package:rev/firebase_options.dart';

import 'auth_exception.dart';
import 'auth_provider.dart';

class FirebaseAuthProvider extends AuthProvider {
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
    } else {
      throw UserNotLoggedInException;
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException();
      }
    } on Exception catch (e) {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> logout() async {
    final user = currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<AuthUser> register(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
        return user;
      } else {
        throw CouldNotRegisterUserException();
      }
    } on Exception catch (e) {
      throw CouldNotRegisterUserException();
    }
  }

  @override
  Future<void> emailVerification() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }
}
