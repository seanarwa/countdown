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
  Map<String, int> duration;

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
        this.duration = _getDuration();
        if (this.duration["totalSeconds"] < 1) {
          timer.cancel();
          _startDeath();
        }
      }),
    );
  }

  void _startDeath() {
    this._isDead = true;
  }

  TableRow _getTableRow(num, suffix) {
    return TableRow(
      children: [
        AutoSizeText(
          duration[num].toString().padLeft(2, '0'),
          style: numberStyle,
          minFontSize: 50,
          textAlign: TextAlign.right,
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            suffix,
            style: textStyle,
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
          print("ERROR: no death time found for user " + user.uid);
        } else {
          print("Successfully fetched death time from DB");
          setState(() {
            _deathTime = new DateTime.now().add(new Duration(seconds: snapshot.value));
            _startTimer();
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
//    if(!widget.isClosed) {
//      return Container();
//    }
    if(duration == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: 50),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
          children: [
            _getTableRow("years", "Y R S\n"),
            _getTableRow("days", "D A Y\n"),
            _getTableRow("hours", "H R S\n"),
            _getTableRow("minutes", "M I N\n"),
            _getTableRow("seconds", "S E C\n"),
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