import 'package:flutter/material.dart';
import 'dart:async';

class TimerPage extends StatefulWidget {
  TimerPage({Key key}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {

  final TextStyle numberStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 70);

  Timer _timer;
  Map<String, int> duration;

  bool _isDead = false;
  var _deathTime = _getTestTimer();

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

  String _getFormattedDuration() {
    if(duration == null) return "";
    return "${duration["years"]}y ${duration["days"]}d ${duration["hours"]}h ${duration["minutes"]}m ${duration["seconds"]}s";
  }

  void _startDeath() {
    this._isDead = true;
  }

  static DateTime _getTestTimer() {
    return new DateTime.now().add(new Duration(hours: 0, minutes: 0, seconds: 10));
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    if(duration == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.25),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
          children: [
            TableRow(children: [Text("${duration["years"]}", style: numberStyle,), Text("YRS"),]),
            TableRow(children: [Text("${duration["days"]}", style: numberStyle,), Text("DAY"),]),
            TableRow(children: [Text("${duration["hours"]}", style: numberStyle,), Text("HRS"),]),
            TableRow(children: [Text("${duration["minutes"]}", style: numberStyle,), Text("MIN"),]),
            TableRow(children: [Text("${duration["seconds"]}", style: numberStyle,), Text("SEC"),]),
          ],
        ),
      ),
    );
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("${duration["years"]}", style: numberStyle,),
              Text("${duration["days"]}", style: numberStyle),
              Text("${duration["hours"]}", style: numberStyle),
              Text("${duration["minutes"]}", style: numberStyle),
              Text("${duration["seconds"]}", style: numberStyle),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("YRS"),
                Text("DAY"),
                Text("HRS"),
                Text("MIN"),
                Text("SEC"),
              ],
            ),
          ),
          RaisedButton(
            child: Text('reset'),
            onPressed: () {
              setState(() {
                _deathTime = _getTestTimer();
                _isDead = false;
                _startTimer();
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

}