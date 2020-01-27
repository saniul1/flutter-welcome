import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fire_plus/models/user.dart';

class UserData extends ChangeNotifier {
  User _user;
  final _userDB = Firestore.instance.collection("users");

  User get user {
    return _user;
  }

  Future<void> fetchAndSetUserData() async {
    final user = await FirebaseAuth.instance.currentUser();
    _user = await getUserData(user.uid);
    ChangeNotifier();
  }

  Future<void> setUserData(User user) async {
    _user = user;
    ChangeNotifier();
  }

  Future<User> getUserData(String id) async {
    final documentSnapshot = await _userDB.document(id).get();
    final user = User.fromSnapshot(documentSnapshot);
    return user;
  }
}
