import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rev/auth/auth_provider.dart';
import 'package:rev/bloc/nav_state.dart';

import 'nav_event.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc(AuthProvider provider)
      : super(const NavStateUninitialized(false, "")) {
    on<NavEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const NavStateLoggedOut(false, exception: null, ""));
      } else {
        emit(const NavStateIsLoading(false, ""));
        emit(NavStateLoggedIn(false, "", user));
      }
    });

    on<NavEventLogIn>(
      (event, emit) async {
        emit(const NavStateLoggedOut(true, exception: null, "Hold On"));

        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.login(
            email,
            password,
          );
          if (user.isEmailVerified) {
            emit(const NavStateLoggedOut(false, exception: null, ""));
            emit(NavStateLoggedIn(false, "", user));
          } else if (!user.isEmailVerified) {
            emit(const NavStateNotVerified(false, ""));
          } else {
            emit(const NavStateLoggedOut(false, "", exception: null));
          }
        } on Exception catch (e) {
          emit(NavStateLoggedOut(false, exception: e, ""));
        }
      },
    );

    on<NavEventGetData>((event, emit) async {
      if (event.hasData) {
        emit(const NavStateDataFetched(false, ""));
      } else {
        emit(const NavStateIsLoading(true, "Hold On"));
      }
    });

    on<NavEventSendVerification>((event, emit) {
      emit(const NavStateNotVerified(false, ""));
    });

    on<NavEventRegister>(
      (event, emit) {
        emit(const NavStateRegistering(false, "", null));
      },
    );

    on<NavEventRegisterUser>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.register(email, password);
        emit(const NavStateGettingUserData(false, ""));
      } on Exception catch (e) {
        emit(NavStateRegistering(false, "", e));
      }
    });

    on<NavEventLogOut>((event, emit) async {
      try {
        await provider.logout();
        emit(const NavStateLoggedOut(false, exception: null, ""));
      } on Exception catch (e) {
        emit(NavStateLoggedOut(false, exception: e, ""));
      }
    });
  }
}
