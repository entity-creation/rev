import 'package:rev/auth/auth_user.dart';

abstract class NavState {
  final bool isLoading;
  final String loadingText;
  const NavState(this.isLoading, this.loadingText);
}

class NavStateUninitialized extends NavState {
  const NavStateUninitialized(super.isLoading, super.loadingText);
}

class NavStateIsLoading extends NavState {
  const NavStateIsLoading(super.isLoading, super.loadingText);
}

class NavStateDataFetched extends NavState {
  const NavStateDataFetched(super.isLoading, super.loadingText);
}

class NavStateLoggedIn extends NavState {
  final AuthUser user;
  const NavStateLoggedIn(super.isLoading, super.loadingText, this.user);
}

class NavStateNotVerified extends NavState {
  const NavStateNotVerified(super.isLoading, super.loadingText);
}

class NavStateRegistering extends NavState {
  final Exception? exception;
  const NavStateRegistering(super.isLoading, super.loadingText, this.exception);
}

class NavStateGettingUserData extends NavState {
  const NavStateGettingUserData(super.isLoading, super.loadingText);
}

class NavStateLoggedOut extends NavState {
  final Exception? exception;

  const NavStateLoggedOut(super.isLoading, super.loadingText,
      {required this.exception});
}
