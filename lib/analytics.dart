import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {

  static final FirebaseAnalytics _analytics = FirebaseAnalytics();

  static void logLogin(String method) {
    _analytics.logLogin(loginMethod: method);
  }

  static void logSignUp(String method) {
    _analytics.logSignUp(signUpMethod: method);
  }

  static void logPageRoute(String pageRoute) {
    _analytics.setCurrentScreen(screenName: pageRoute);
  }

  static void logEvent(String name, [Map<String, dynamic> parameters]) {
    _analytics.logEvent(name: name, parameters: parameters);
  }

}