import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fire_plus/models/friends.dart';
import 'package:flutter_fire_plus/models/user.dart';
import 'package:flutter_fire_plus/services/auth.dart';

class UserData with ChangeNotifier {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final _currentUserDB = Firestore.instance.collection("users");

  User _user;
  User _currentUser;
  var _isFriend = false;
  List<Friend> _friends;

  User get currentUser {
    return _currentUser;
  }

  User get user {
    return _user;
  }

  bool get isFriend {
    return _isFriend;
  }

  List<Friend> get friends {
    return _friends;
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
    try {
      final documentSnapshot = await _currentUserDB.document(id).get();
      final user = User.fromSnapshot(documentSnapshot);
      return user;
    } catch (e) {
      print('error: $e');
      throw e;
    }
  }

  Future<List<Friend>> getFriends(String id) async {
    final friendsSnapshot = await _db
        .collection('users')
        .document(id)
        .collection('friends')
        .getDocuments();
    final friends = Friends.fromDocumentSnapShot(friendsSnapshot);
    _friends = friends.friendsList;
    notifyListeners();
    return friends.friendsList;
  }

  Future<bool> checkIfFriendFromServer(String id) async {
    final user = await Auth.getCurrentUser();
    final friend = await _db
        .collection('users')
        .document(id)
        .collection('friends')
        .document(user.uid)
        .get();
    return friend.data != null;
  }

  Future<void> checkFriend(String id) async {
    _isFriend = await checkIfFriendFromServer(id);
    notifyListeners();
    return;
  }

  Future<void> addToFriendList(String id) async {
    final user = await Auth.getCurrentUser();
    final DocumentReference userRef = _db
        .collection('users')
        .document(user.uid)
        .collection('friends')
        .document(id);
    final DocumentReference friendRef = _db
        .collection('users')
        .document(id)
        .collection('friends')
        .document(user.uid);
    await userRef.setData({
      'id': id,
      'initiator': user.uid,
      'createdAt': FieldValue.serverTimestamp()
    });
    await friendRef.setData({
      'id': user.uid,
      'initiator': user.uid,
      'createdAt': FieldValue.serverTimestamp()
    });
    return;
  }
}
