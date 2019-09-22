import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {

  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseDatabase _db = FirebaseDatabase.instance;

  static checkState(context, {redirect}) {
    _auth.onAuthStateChanged.listen((user) {
      if(user == null) {
        final path = redirect ?? '/login';
        print("User is not signed in, redirecting to $path ...");
        Navigator.pushReplacementNamed(context, path);
      }
    });
  }

  static _checkUserInDB() {
    DatabaseReference _userRef = _db.reference().child('user');
    getUser().then((user) {
      _userRef.child(user.uid).once().then((snapshot) {
        if(snapshot.value == null) {
          print("New user detected. Pushing new user to db ...");
          _pushUserToDB(user);
        }
      });
    });
  }

  static _pushUserToDB(user) {
    DatabaseReference _userRef = _db.reference().child('user');
    DatabaseReference _pushRef = _userRef.child(user.uid);
    _pushRef.set({
      'display_name': user.displayName,
      'email': user.email,
      'photo_url': user.photoUrl,
    });
  }

  static getUser() {
    return _auth.currentUser();
  }

  static isSignedIn() {
    return (getUser() != null);
  }

  static authState() {
    return _auth.onAuthStateChanged;
  }

  static googleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("Signed in user: " + user.displayName);

    _checkUserInDB();

    return user;
  }

  static signOut() {
    return _auth.signOut();
  }

}