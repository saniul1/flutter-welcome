import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_fire_plus/models/http_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class Auth extends ChangeNotifier implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _userId;
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;

  String get userId {
    return _userId;
  }

  bool get isLoggedIn {
    return _authStatus == AuthStatus.LOGGED_IN;
  }

  Future<bool> checkAuth() async {
    return await getCurrentUser().then((user) {
      if (user != null) {
        _userId = user?.uid;
      }
      _authStatus =
          user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
    }).then((_) {
      return _authStatus == AuthStatus.LOGGED_IN;
    });
  }

  Future<String> signIn(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      _saveUser(user.uid);
      return user.uid;
    } catch (error) {
      print(error.code);
      print(error.message);
      throw HttpException(error.code, error.message);
    }
  }

  Future<String> signUp(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      _saveUser(user.uid);
      return user.uid;
    } catch (error) {
      print(error.code);
      throw HttpException(error.code, error.message);
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      _userId = '';
      _authStatus = AuthStatus.NOT_LOGGED_IN;
      print(_authStatus);
      notifyListeners();
    } catch (e) {
      print(e);
    }
    return _firebaseAuth.signOut();
  }

  void _saveUser(String id) {
    if (id != null && id.length > 0) {
      _userId = id;
      _authStatus = AuthStatus.LOGGED_IN;
      print(_authStatus);
      notifyListeners();
    }
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
