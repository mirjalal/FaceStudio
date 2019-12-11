import 'package:flutter/material.dart';
import 'package:salon_reservations/services/auth.dart';

class Home extends StatelessWidget {

  final AuthService _authService = AuthService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Welcome to FaceStudio'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text('Logout', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await _authService.signOut();
            },
          )
        ],
      ),
    );
  }
}

