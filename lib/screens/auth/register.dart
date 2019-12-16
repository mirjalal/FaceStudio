import 'dart:io';

import 'package:face_studio/generated/i18n.dart';
import 'package:face_studio/services/auth.dart';
import 'package:face_studio/shared/contants.dart';
import 'package:face_studio/shared/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _authService = AuthService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController = TextEditingController();
  
  File _imageFile;
  String _retrieveDataError;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() => _imageFile = image);
  }

  bool _loading = false;

  DateTime selectedDate;// = DateTime.now();
  DateTime now = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year - 18),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    final _translations = I18n.of(context);

    ///
    /// BEGIN: Lost image section
    /// 
    Text _getRetrieveErrorWidget() {
      if (_retrieveDataError != null) {
        final Text result = Text(_retrieveDataError);
        _retrieveDataError = null;
        return result;
      }
      return null;
    }

    Widget _previewImage() {
      final Text retrieveError = _getRetrieveErrorWidget();
      if (retrieveError != null)
        return retrieveError;

      if (_imageFile != null)
        return Image.file(_imageFile, width: 200.0, height: 200.0, fit: BoxFit.cover);
      else
        return placeholderImage;
    }

    Future<void> retrieveLostData() async {
      final LostDataResponse response = await ImagePicker.retrieveLostData();
      if (response.isEmpty)
        return;

      if (response.file != null) {
          // setState(() {
            _imageFile = response.file;
          // });
      } else
        _retrieveDataError = response.exception.code;
    }

    /// Sources: 
    /// https://github.com/flutter/plugins/blob/master/packages/image_picker/example/lib/main.dart
    /// https://pub.dev/packages/image_picker#-readme-tab-
    Widget profileImage = Center(
        child: Platform.isAndroid
          ? FutureBuilder<void>(
            future: retrieveLostData(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return _previewImage();
                case ConnectionState.none:
                case ConnectionState.waiting:
                default:
                  return placeholderImage;
              }
            },
        ) : _previewImage()
    );
    /// 
    /// END: Lost image widget
    /// 
    
    return _loading ? Loading() : Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: appBarWithCustomStyle(_translations.registrationPageTitle),
        actions: <Widget>[
          FlatButton(
            child: Text(_translations.signIn, style: TextStyle(color: Colors.white)),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              profileImage,
              InkWell(
                onTap: getImage,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 50.0, right: 50.0, bottom: 10.0),
                  child: Text(_translations.pickImage),
                ),
              ),

              SizedBox(height: 20.0),
              RaisedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text(_translations.birthdate),
              ),
              SizedBox(height: 20.0),
              
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: 'https://picsum.photos/250?image=9',
              ),

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
              TextFormField(
                controller: _passwordRepeatController,
                decoration: InputDecoration(
                  labelText: _translations.confirmPassword,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (String password) {
                  if (password.length < 8)
                    return _translations.passwordLengthError;
                  if (password != _passwordController.text)
                    return _translations.passwordsNotMatch;
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
                  _translations.register,
                  style: TextStyle(color: Colors.white),
                ), 
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() => _loading = true);
                    await _authService.registerUser(_emailController.text, _passwordController.text);
                    if (mounted)
                      setState(() => _loading = false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
