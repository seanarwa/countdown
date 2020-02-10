import 'package:countdown/screens/disclaimer.dart';
import 'package:countdown/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'package:countdown/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    _checkDisclaimer();

    Auth.authState().listen((user) {
      if(user != null) {
        print("User is signed in, redirecting to HomePage ...");
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
        return;
      }
    });
  }

  void _checkDisclaimer() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    if(!(p.getBool("agreeDisclaimer") ?? false)) {
      Navigator.of(context).pushNamed(DisclaimerPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Container(),),
            Align(
              alignment: Alignment.center,
              child: Column(
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
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text("Login to accept your fate ..."),
            ),
            Expanded(child: Container(),),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.library_books,
                    color: Colors.white,
                  ),
                  FlatButton(
                    child: Text(
                      'Disclaimer',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pushNamed(DisclaimerPage.routeName);
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