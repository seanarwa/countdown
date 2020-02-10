import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisclaimerPage extends StatefulWidget {
  DisclaimerPage({Key key}) : super(key: key);

  static final String routeName = '/disclaimer';

  @override
  _DisclaimerPageState createState() => _DisclaimerPageState();
}

class _DisclaimerPageState extends State<DisclaimerPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 50, bottom: 10),
                    child: Text(
                      "Disclaimer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: Text(
                      "The contents presented in this application are solely for entertainment and fictional purposes.\n\n"
                          "The developers and publishers are not offering it as legal, accounting, or other professional services advice. While best efforts have been used in developing this application, the developer and publisher make no representations or warranties of any kind and assume no liabilities of any kind with respect to the accuracy or completeness of the contents and specifically disclaim any implied warranties of merchantability or fitness of use for a particular purpose.\n\n"
                          "Neither the developer nor the publisher shall be held liable or responsible to any person or entity with respect to any loss or incidental or consequential damages caused, or alleged to have been caused, directly or indirectly, by the information or programs contained herein. No warranty may be created or extended by sales representatives or written sales materials. Every company is different and the advice and strategies contained herein may not be suitable for your situation.\n\n"
                          "The contents are fictional. Any likeness to actual persons, either living or dead, is strictly coincidental.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10, bottom: 10),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        child: Text(
                          "I Agree",
                          style: TextStyle(
                            color: Colors.red[500],
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () async {
                          SharedPreferences p = await SharedPreferences.getInstance();
                          p.setBool("agreeDisclaimer", true);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}