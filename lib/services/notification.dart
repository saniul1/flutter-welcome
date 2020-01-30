import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

/// ***Deprecated***
/// use notification widget instead

class Notifications with ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _message;
  String _token;

  String get message {
    return _message;
  }

  String get token {
    return _token;
  }

  Future<void> register() async {
    _token = await _firebaseMessaging.getToken();
    return;
  }

  void getMessages() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      _message = message["notification"]["title"];
      notifyListeners();
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      _message = message["notification"]["title"];
      notifyListeners();
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      _message = message["notification"]["title"];
      notifyListeners();
    });
  }
}
