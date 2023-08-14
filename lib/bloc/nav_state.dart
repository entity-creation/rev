import 'package:rev/auth/auth_user.dart';

abstract class NavState {
  const NavState();
}

class NavStateUninitialized extends NavState {
  const NavStateUninitialized();
}

class NavStateIsLoading extends NavState {
  final String loadingText;
  const NavStateIsLoading({this.loadingText = "Hold on"});
}

class NavStateDataFetched extends NavState {
  const NavStateDataFetched();
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
