import 'package:flutter/material.dart';
import 'package:flutter_website_app/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: _AccentShadow(child: LoginForm()),
          ),
        ),
      ),
    );
  }
}

class _AccentShadow extends StatelessWidget {
  final Widget child;

  _AccentShadow({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          spreadRadius: -15,
          blurRadius: 20,
          color: Theme.of(context).accentColor,
        )
      ], color: Colors.black),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: child,
      ),
    );
  }
}
