import 'package:cached_network_image/cached_network_image.dart';
import 'package:countdown/screens/disclaimer.dart';
import 'package:countdown/screens/donation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:countdown/auth.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.isClosed, this.onClick}) : super(key: key);

  final bool isClosed;
  final onClick;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    Auth.getUser().then((user) {
      setState(() {
        this.user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(user == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: new Icon(widget.isClosed ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
              color: Colors.white,
              onPressed: () {
                widget.onClick();
              },
            ),
            Container(
              width: 80.0,
              height: 80.0,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(user.photoUrl),
                ),
              ),
            ),
            Text(user.displayName, style: TextStyle(fontSize: 20),),
            Expanded(
              child: Container(),
            ),
            Container(
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
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                      Icons.attach_money,
                      color: Colors.green[500],
                  ),
                  FlatButton(
                    child: Text(
                      'Donate',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    textColor: Colors.green[500],
                    onPressed: () {
                      Navigator.of(context).pushNamed(DonationPage.routeName);
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                      Icons.exit_to_app,
                      color: Colors.red[500],
                  ),
                  FlatButton(
                    child: Text(
                      'Sign out',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    textColor: Colors.red[500],
                    onPressed: Auth.signOut,
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

