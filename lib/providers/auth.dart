import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_fire_plus/models/http_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class Auth extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _userId;
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;

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
      return user.uid;
    } catch (error) {
      print(error.code);
      print(error.message);
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
    } catch (e) {
      throw e;
    }
    return _firebaseAuth.signOut();
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
