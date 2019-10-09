import 'package:flutter/material.dart';
import 'dart:async';
import 'package:countdown/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TimerPage extends StatefulWidget {
  TimerPage({Key key, this.isClosed}) : super(key: key);

  final bool isClosed;

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with SingleTickerProviderStateMixin {

  static final FirebaseDatabase _db = FirebaseDatabase.instance;

  TextStyle numberStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 75);
  TextStyle textStyle = TextStyle(fontWeight: FontWeight.bold);

  Timer _timer;
  Map<String, int> _duration;

  double _opacity = 0.0;
  double _buttonOpacity = 0.0;
  bool _isFirstTimeUser = false;
  bool _isDead = false;
  DateTime _deathTime;

  Map<String, int> _getDuration() {
    Duration diff = _deathTime.difference(new DateTime.now());
    int totalSeconds = diff.inSeconds;
    int years = (totalSeconds ~/ 31536000);
    int days = (totalSeconds ~/ 86400) % 365;
    int hours = (totalSeconds ~/ 3600) % 24;
    int minutes = (totalSeconds ~/ 60) % 60;
    int seconds = totalSeconds % 60;
    totalSeconds = years*31536000 + days*86400 + hours*3600 + minutes*60 + seconds;
    return {
      "years": years,
      "days" : days,
      "hours": hours,
      "minutes": minutes,
      "seconds": seconds,
      "totalSeconds": totalSeconds,
    };
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        this._duration = _getDuration();
        if (this._duration["totalSeconds"] < 1) {
          timer.cancel();
          _startDeath();
        }
      }),
    );
  }

  void _startDeath() {
    this._isDead = true;
  }

  TableRow _getTableRow(num, suffix, color) {
    return TableRow(
      children: [
        AutoSizeText(
          _duration[num].toString().padLeft(2, '0'),
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 75),
          minFontSize: 50,
          textAlign: TextAlign.right,
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            suffix,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
      ]
    );
  }

  @override
  void initState() {
    super.initState();

    // check user death time
    DatabaseReference _userRef = _db.reference().child('user');
    Auth.getUser().then((user) {
      if(user == null) {
        print("ERROR: Auth user is null");
        return;
      }
      _userRef.child('${user.uid}/deathTime').once().then((snapshot) {
        if(snapshot.value == null) {
          print("No death time found for user " + user.uid);
          print("Initializing death time for user " + user.uid + " ...");
          _fetchFirstDeathTime();
        } else {
          print("Successfully fetched death time from DB");
          setState(() {
            _deathTime = new DateTime.fromMillisecondsSinceEpoch(snapshot.value * 1000);
            _startTimer();
          });
        }
      });
    });

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _animateUI());
  }

  void _fetchFirstDeathTime() {

    setState(() => _isFirstTimeUser = true);

    DatabaseReference _userRef = _db.reference().child('user');
    Auth.getUser().then((user) {
      if(user == null) {
        print("ERROR: Auth user is null");
        return;
      }
      _userRef.child(user.uid).onChildAdded.listen((event) {
        if(event.snapshot.key == "deathTime") {
          print("Successfully fetched death time from DB");
          setState(() {
            _deathTime = new DateTime.fromMillisecondsSinceEpoch(event.snapshot.value * 1000);
            _startTimer();
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_isFirstTimeUser) {
      return _renderFirstTime();
    }
    if(_duration == null) {
      return _renderLoading();
    }
    return _renderTimer();
  }

  void _animateUI() {
    setState(() {
      _opacity = 1.0;
    });
    Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        _buttonOpacity = 1.0;
      });
    });
  }

  Widget _renderLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _renderFirstTime() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
            opacity: _opacity,
            duration: Duration(seconds: 2),
            // The green box must be a child of the AnimatedOpacity widget.
            child: Image.asset(
              'images/app_icon.png',
              width: 200,
              height: 200,
            ),
          ),
          AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
            opacity: _opacity,
            duration: Duration(seconds: 4),
            // The green box must be a child of the AnimatedOpacity widget.
            child: Text('Looks like you are new here.\n'
                'We are preparing your fate ...'),
          ),
          AnimatedOpacity(
            opacity: _buttonOpacity,
            duration: Duration(seconds: 2),
            child: Container(
              margin: EdgeInsets.all(20),
              child: _deathTime == null ?
              CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              )
              : RaisedButton(
                child: Text("Accept your fate"),
                onPressed: () {
                  _isFirstTimeUser = false;
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _renderTimer() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: 50),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
          children: [

            _getTableRow("years", "Y R S\n", _duration["years"] == 0 
                                         ? Colors.red : Colors.white),
            
            _getTableRow("days", "D A Y\n", _duration["days"] == 0
                                         && _duration["years"] == 0
                                         ? Colors.red : Colors.white),

            _getTableRow("hours", "H R S\n", _duration["hours"] == 0
                                         &&_duration["days"] == 0
                                         && _duration["years"] == 0
                                         ? Colors.red : Colors.white),

            _getTableRow("minutes", "M I N\n", _duration["minutes"] == 0
                                         &&_duration["hours"] == 0
                                         &&_duration["days"] == 0
                                         && _duration["years"] == 0
                                         ? Colors.red : Colors.white),

            _getTableRow("seconds", "S E C\n", _duration["seconds"] == 0
                                         &&_duration["minutes"] == 0
                                         &&_duration["hours"] == 0
                                         &&_duration["days"] == 0
                                         && _duration["years"] == 0
                                         ? Colors.red : Colors.white),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

}