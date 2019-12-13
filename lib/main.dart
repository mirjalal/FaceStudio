import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:face_studio/models/user.dart';
import 'package:face_studio/screens/wrapper.dart';
import 'package:face_studio/services/auth.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(
          debugShowCheckedModeBanner: !kReleaseMode, // removes "Debug" banner if in Release mode (https://stackoverflow.com/a/55612795/4057688)
          theme: ThemeData(
            cupertinoOverrideTheme: CupertinoThemeData(
              primaryColor: Colors.black,
            ),
            cursorColor: Colors.black,
            primaryColor: Colors.black,
            accentColor: Colors.red[900],
          ),
          home: Wrapper(),
        ),
      );
    }
}
