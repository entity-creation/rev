import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rev/auth/auth_provider.dart';
import 'package:rev/bloc/nav_state.dart';

import 'nav_event.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc(AuthProvider provider) : super(const NavStateUninitialized()) {
    on<NavEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const NavStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } else {
        emit(NavStateLoggedIn(user));
      }
    });

    on<NavEventLogIn>(
      (event, emit) async {
        emit(const NavStateLoggedOut(exception: null, isLoading: true));

        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.login(
            email,
            password,
          );
          if (user != null) {
            emit(const NavStateLoggedOut(exception: null, isLoading: false));
            emit(NavStateLoggedIn(user));
          } else {
            emit(const NavStateLoggedOut(exception: null, isLoading: false));
          }
        } on Exception catch (e) {
          emit(NavStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );

    on<NavEventLogOut>((event, emit) async {
      try {
        await provider.logout();
        emit(const NavStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(NavStateLoggedOut(exception: e, isLoading: false));
      }
    });
  }
}
