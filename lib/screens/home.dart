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
  final PanelController _pc = new PanelController();

  void _onClick() {
    if(_isClosed) {
      _pc.open();
    } else {
      _pc.close();
    }
  }

  @override
  void initState() {
    super.initState();
    Auth.checkState(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: _pc,
        minHeight: 50,
        panel: ProfilePage(isClosed: _isClosed, onClick: _onClick),
        body: TimerPage(isClosed: _isClosed),
        onPanelOpened: () {
          setState(() => _isClosed = _pc.isPanelClosed());
        },
        onPanelClosed: () {
          setState(() => _isClosed = _pc.isPanelClosed());
        },
      )
    );
  }
}