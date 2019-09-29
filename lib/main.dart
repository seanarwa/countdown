import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/lib.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // set forced vertical orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Countdown',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        canvasColor: Colors.black,
        fontFamily: 'TeXGyreAdventor',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontFamily: 'TeXGyreAdventor', color: Colors.white),
          title: TextStyle(fontSize: 36.0, fontFamily: 'TeXGyreAdventor', color: Colors.white),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'TeXGyreAdventor', color: Colors.white),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        '/login': (BuildContext context) => LoginPage(),
      }
    );
  }
}
