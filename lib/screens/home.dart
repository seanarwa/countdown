import 'package:flutter/material.dart';

import 'package:countdown/auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'timer.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var _isClosed = true;

  @override
  void initState() {
    super.initState();
    Auth.checkState(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: 50,
        panel: ProfilePage(isClosed: _isClosed),
        body: TimerPage(),
        onPanelOpened: () {
          setState(() {
            _isClosed = false;
          });
        },
        onPanelClosed: () {
          setState(() {
            _isClosed = true;
          });
        },
      )
    );
  }
}