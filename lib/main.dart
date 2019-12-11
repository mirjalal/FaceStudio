import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_reservations/models/user.dart';
import 'package:salon_reservations/screens/wrapper.dart';
import 'package:salon_reservations/services/auth.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(
          debugShowCheckedModeBanner: !kReleaseMode, // removes "Debug" banner if in Release mode (https://stackoverflow.com/a/55612795/4057688)
          theme: ThemeData(
            cursorColor: Colors.black,
            primaryColor: Colors.black,
            accentColor: Colors.red[900],
          ),
          home: Wrapper(),
        ),
      );
    }
}
