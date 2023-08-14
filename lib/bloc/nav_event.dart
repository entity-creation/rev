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
  final AsyncSnapshot snapshot;

  const NavEventGetData(this.snapshot);
}

class NavEventLogOut extends NavEvent {
  const NavEventLogOut();
}
