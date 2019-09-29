import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
  final PanelController _pc = new PanelController();

  void _onClick() {
    if(_isClosed) {
      _pc.open();
    } else {
      _pc.close();
    }
  }

  void _onPanelStateChanged() {
    setState(() => _isClosed = _pc.isPanelClosed());
  }

  @override
  void initState() {
    super.initState();
    Auth.authState().listen((user) {
      if(user == null) {
        print("User is not signed in, redirecting to LoginPage ...");
        Navigator.of(context).pushReplacementNamed("/login");
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: _pc,
        minHeight: 50,
        backdropEnabled: true,
        backdropOpacity: 1.0,
        color: Colors.transparent,
        panel: ProfilePage(isClosed: _isClosed, onClick: _onClick),
        body: TimerPage(isClosed: _isClosed),
        onPanelOpened: _onPanelStateChanged,
        onPanelClosed: _onPanelStateChanged,
      )
    );
  }
}