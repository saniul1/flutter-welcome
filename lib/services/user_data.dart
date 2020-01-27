import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fire_plus/models/user.dart';

class UserData with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _userDB = Firestore.instance.collection("users");

  User _user;
  var _isFriend = false;

  User get user {
    return _user;
  }

  bool get isFriend {
    return _isFriend;
  }

  Future<void> fetchAndSetUserData() async {
    final user = await FirebaseAuth.instance.currentUser();
    _user = await getUserData(user.uid);
    notifyListeners();
  }

  Future<void> setUserData(User user) async {
    _user = user;
    notifyListeners();
  }

  Future<User> getUserData(String id) async {
    final documentSnapshot = await _userDB.document(id).get();
    final user = User.fromSnapshot(documentSnapshot);
    return user;
  }

  Future<bool> checkIfFriendFromServer(String id) async {
    final user = await getCurrentUser();
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
    final user = await getCurrentUser();
    final DocumentReference userRef = _userDB.document(user.uid);
    final DocumentReference friendRef = _userDB.document(id);
    await userRef.updateData({
      'friends': FieldValue.arrayUnion([id])
    });
    await friendRef.updateData({
      'friends': FieldValue.arrayUnion([user.uid])
    });
    return;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }
}
