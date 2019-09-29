import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamed("/login");
        });
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    // set forced vertical orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      body: SlidingUpPanel(
        controller: _pc,
        minHeight: 50,
        backdropEnabled: true,
        backdropOpacity: 1.0,
        color: Colors.transparent,
        panel: new ProfilePage(isClosed: _isClosed, onClick: _onClick),
        body: new TimerPage(isClosed: _isClosed),
        onPanelOpened: _onPanelStateChanged,
        onPanelClosed: _onPanelStateChanged,
      )
    );
  }
}