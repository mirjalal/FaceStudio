import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_reservations/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _authService = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Sign in to FaceStudio'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Google Sign in'),
              onPressed: () async {
                dynamic result = await _authService.googleSignIn();
                if (result == null)
                  print('error signing in');
                else
                  print(result.uid);
              },
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 16.0),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (String email) {
                      bool isValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
                      if (email.isEmpty || !isValid)
                        return 'Please enter email';
                      return null;
                    },
                  ),

                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    validator: (String password) {
                      if (password.length < 6)
                        return 'Please enter a password 6+ chars long';
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
                      'Sign in',
                      style: TextStyle(color: Colors.white)
                    ), 
                    onPressed: () async {
                      if (_formKey.currentState.validate()){
                        dynamic create = await _authService.emailPasswordSignIn(_emailController.text, _passwordController.text);
                        print(create);
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
