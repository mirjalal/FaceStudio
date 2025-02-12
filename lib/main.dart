import 'package:face_studio/generated/i18n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
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
          localizationsDelegates: [
            I18n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('az'),
            const Locale('en'),
            const Locale('ru'),
          ],
          theme: ThemeData(
            cupertinoOverrideTheme: CupertinoThemeData(
              primaryColor: Colors.black,
            ),
            cursorColor: Colors.black,
            primaryColor: Colors.black,
            accentColor: Colors.red[900],
            textTheme: GoogleFonts.redHatDisplayTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          home: Wrapper(),
        ),
      );
    }
}
