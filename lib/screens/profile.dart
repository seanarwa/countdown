import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:countdown/auth.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.isClosed}) : super(key: key);

  final bool isClosed;

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
      backgroundColor: Colors.black,
      body: Container(
//        decoration: const BoxDecoration(
//          border: Border(
//            top: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//            left: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//            right: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//            bottom: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//          ),
//        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                IconButton(
                  icon: new Icon(widget.isClosed ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                  color: Colors.white,
                  onPressed: () {
                    print("pressed");
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
                Text(user.displayName),
                FlatButton(
                  child: Text('Sign out'),
                  textColor: Colors.white,
                  onPressed: Auth.signOut,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

