import 'package:flutter/material.dart';
import 'package:face_studio/screens/auth/sign_in.dart';
import 'package:face_studio/screens/auth/register.dart';

class Authenticate extends StatefulWidget {
    @override
    _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
      return showSignIn ? SignIn(toggleView: toggleView) : Register(toggleView: toggleView); 
  }
}
