import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  static final FirebaseAnalytics analytics = FirebaseAnalytics();

  static Future<void> logLogin(String methodUsed) {
    return analytics.logLogin(loginMethod: methodUsed);
  }

  static Future<void> logSignUp(String methodUsed) {
    return analytics.logSignUp(signUpMethod: methodUsed);
  }

  static Future<void> setUserType(String type, String value) {
    return analytics.setUserProperty(name: type, value: value);
  }

  static void registerCustomEvent(
      String eventName, Map<String, dynamic> value) {
    analytics.logEvent(name: eventName, parameters: value);
  }

  static registerUserNavigation(String path) {
    analytics.setCurrentScreen(screenName: path);
  }
}
