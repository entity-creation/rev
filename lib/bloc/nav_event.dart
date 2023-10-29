import 'package:flutter/material.dart';

@immutable
abstract class NavEvent {
  const NavEvent();
}

class NavEventInitialize extends NavEvent {
  const NavEventInitialize();
}

class NavEventLogIn extends NavEvent {
  final String email;
  final String password;

  const NavEventLogIn(
    this.email,
    this.password,
  );
}

class NavEventGetData extends NavEvent {
  final bool hasData;

  const NavEventGetData(this.hasData);
}

class NavEventLogOut extends NavEvent {
  const NavEventLogOut();
}

class NavEventRegister extends NavEvent {
  const NavEventRegister();
}

class NavEventRegisterUser extends NavEvent {
  final String email;
  final String password;

  const NavEventRegisterUser({required this.email, required this.password});
}

class NavEventSendVerification extends NavEvent {
  const NavEventSendVerification();
}
