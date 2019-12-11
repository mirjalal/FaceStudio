import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:face_studio/models/user.dart';
import 'package:face_studio/screens/auth/authenticate.dart';
import 'package:face_studio/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // return either Home or Authenticate
    return user == null ? Authenticate() : Home();
  }
}
