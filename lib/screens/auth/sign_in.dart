import 'package:face_studio/generated/i18n.dart';
import 'package:face_studio/shared/contants.dart';
import 'package:flutter/material.dart';
import 'package:face_studio/services/auth.dart';
import 'package:face_studio/shared/loading_widget.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _authService = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final _translations = I18n.of(context);

    return _loading ? Loading() : Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: appBarWithCustomStyle(_translations.signInPageTitle),
        actions: <Widget>[
          FlatButton(
            child: Text(_translations.gotoRegistrationPage, style: TextStyle(color: Colors.white)),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))
              ),
              child: Text(_translations.googleSignIn),
              onPressed: () async {
                setState(() => _loading = true);
                await _authService.googleSignIn();
                if (mounted)
                  setState(() => _loading = false);
              },
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: _translations.email,
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 16.0),
                    keyboardType: TextInputType.emailAddress,
                    validator: (String email) {
                      bool isValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
                      if (email.isEmpty || !isValid)
                        return _translations.enterValidEmail;
                      return null;
                    },
                  ),

                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: _translations.password,
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (String password) {
                      if (password.length < 8)
                        return _translations.passwordLengthError;
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 20.0),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                    ),
                    color: Theme.of(context).accentColor,
                    child: Text(
                      _translations.signIn,
                      style: TextStyle(color: Colors.white)
                    ), 
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() => _loading = true);
                        await _authService.emailPasswordSignIn(_emailController.text, _passwordController.text);
                        // todo(check if email is verified)
                        if (mounted)
                          setState(() => _loading = false);
                      }
                    },
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
