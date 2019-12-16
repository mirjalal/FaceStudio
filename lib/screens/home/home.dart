import 'package:face_studio/generated/i18n.dart';
import 'package:face_studio/models/user.dart';
import 'package:face_studio/shared/contants.dart';
import 'package:flutter/cupertino.dart';
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
        title: appBarWithCustomStyle(_translations.welcome(user.fullName)),
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
      body: AbsorbPointer(
        absorbing: user.isEmailVerified, // if true all inner widgets will be disabled
        child: Column(
          children: <Widget>[
            if (!user.isEmailVerified)
              Card(
                margin: EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ListTile(
                      // leading: Icon(Icons.album),
                      title: Text(_translations.almostDone, style: TextStyle(fontSize: 20.0)),
                      subtitle: Text(_translations.verifyEmail(user.email), style: TextStyle(fontSize: 16.0)),
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('RESEND EMAIL'),
                          onPressed: () { user.sendEmailVerification(); },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

