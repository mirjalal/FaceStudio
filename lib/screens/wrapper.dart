import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_reservations/models/user.dart';
import 'package:salon_reservations/screens/auth/authenticate.dart';
import 'package:salon_reservations/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // return either Home or Authenticate
    return user == null ? Authenticate() : Home();
  }
}
