import 'package:countdown/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'package:countdown/auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  static final String routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    super.initState();
    Auth.authState().listen((user) {
      if(user != null) {
        print("User is signed in, redirecting to HomePage ...");
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/app_icon.png',
              width: 200,
              height: 200,
            ),
            Container(margin: EdgeInsets.all(10)),
            GoogleSignInButton(
              onPressed: Auth.googleSignIn,
            ),
          ],
        ),
      ),
    );
  }
}