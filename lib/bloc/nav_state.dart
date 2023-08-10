import 'package:rev/auth/auth_user.dart';

abstract class NavState {
  const NavState();
}

class NavStateUninitialized extends NavState {
  const NavStateUninitialized();
}

class NavStateLoggedIn extends NavState {
  final AuthUser user;
  const NavStateLoggedIn(this.user);
}

class NavStateLoggedOut extends NavState {
  final Exception? exception;
  final bool isLoading;

  const NavStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });
}
