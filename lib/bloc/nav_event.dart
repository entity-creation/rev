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

  const NavEventLogIn({
    required this.email,
    required this.password,
  });
}

class NavEventLogOut extends NavEvent {
  const NavEventLogOut();
}
