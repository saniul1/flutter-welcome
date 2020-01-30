import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fire_plus/models/user.dart';
import 'package:flutter_fire_plus/services/auth.dart';

class UserData with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _currentUserDB = Firestore.instance.collection("users");

  User _user;
  User _currentUser;
  var _isFriend = false;

  User get currentUser {
    return _currentUser;
  }

  User get user {
    return _user;
  }

  bool get isFriend {
    return _isFriend;
  }

  Future<void> fetchAndSetUserData() async {
    final user = await FirebaseAuth.instance.currentUser();
    _user = await getUserData(user.uid);
    _currentUser = await getUserData(user.uid);
    notifyListeners();
  }

  Future<void> setUserData(User user) async {
    _currentUser = user;
    notifyListeners();
  }

  Future<User> getUserData(String id) async {
    final documentSnapshot = await _currentUserDB.document(id).get();
    final user = User.fromSnapshot(documentSnapshot);
    return user;
  }

  Future<bool> checkIfFriendFromServer(String id) async {
    final user = await Auth.getCurrentUser();
    final userData = await getUserData(user.uid);
    var isFriend = false;
    if (userData.friends != null) {
      userData.friends.forEach((friendID) {
        if (friendID == id) isFriend = true;
      });
    }
    return isFriend;
  }

  Future<void> checkFriend(String id) async {
    _isFriend = await checkIfFriendFromServer(id);
    notifyListeners();
    return;
  }

  Future<void> addToFriendList(String id) async {
    final user = await Auth.getCurrentUser();
    final DocumentReference userRef = _currentUserDB.document(user.uid);
    final DocumentReference friendRef = _currentUserDB.document(id);
    await userRef.updateData({
      'friends': FieldValue.arrayUnion([id])
    });
    await friendRef.updateData({
      'friends': FieldValue.arrayUnion([user.uid])
    });
    return;
  }
}
