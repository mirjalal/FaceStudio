import 'package:face_studio/generated/i18n.dart';
import 'package:face_studio/models/user.dart';
import 'package:flutter/material.dart';
import 'package:face_studio/services/auth.dart';

class Home extends StatelessWidget {

  final AuthService _authService = AuthService();
  final User user;

  Home({@required this.user}) : super();
  
  @override
  Widget build(BuildContext context) {
    final I18n _translations = I18n.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(_translations.welcome(user.fullName)),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text(_translations.logout, style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await _authService.signOut();
            },
          )
        ],
      ),
    );
  }
}

