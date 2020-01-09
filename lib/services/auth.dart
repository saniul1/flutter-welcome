import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_fire_plus/models/http_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class Auth extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Firestore _db = Firestore.instance;
  String _userId;

  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;

  String get userId {
    return _userId;
  }

  Future<bool> checkAuth() async {
    return await getCurrentUser().then((user) {
      _authStatus =
          user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      _userId = user.uid;
    }).then((_) {
      return _authStatus == AuthStatus.LOGGED_IN;
    });
  }

  Future<void> _updateUserData(
    FirebaseUser user, {
    String name,
    String phoneNumber,
  }) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
    final snapshot = await ref.get();
    final bool isNewUser = snapshot.data == null;
    print('isNewUser: $isNewUser');
    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName == null ? name : user.displayName,
      'phoneNumber': user.phoneNumber == null ? phoneNumber : user.phoneNumber,
      if (isNewUser) 'createdOn': DateTime.now(),
      'lastSeen': DateTime.now(),
    }, merge: true);
  }

  Future<String> signIn(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await _updateUserData(user);
      _userId = user.uid;
      return user.uid;
    } catch (error) {
      print(error.code);
      print(error.message);
      throw HttpException(error.code, error.message);
    }
  }

  Future<String> signUp({String email, String password, String name}) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await _updateUserData(user, name: name);
      _userId = user.uid;
      return user.uid;
    } catch (error) {
      print(error.code);
      print(error.message);
      throw HttpException(error.code, error.message);
    }
  }

  Future<void> verifyPhone(
    String phoneNumber, {
    PhoneCodeSent onSuccess,
    PhoneVerificationFailed onFailed,
    PhoneCodeAutoRetrievalTimeout onTimeout,
  }) async {
    // print('Verifying $phoneNumber');
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (_) {
          // print('verificationCompleted: $_');
        },
        verificationFailed: onFailed,
        codeSent: onSuccess,
        codeAutoRetrievalTimeout: onTimeout,
      );
    } catch (error) {
      print(error.code);
      print(error.message);
      throw HttpException(error.code, error.message);
    }
  }

  Future<String> verifyOTP({String id, String otp, String phoneNo}) async {
    try {
      final AuthCredential _authCredential =
          PhoneAuthProvider.getCredential(verificationId: id, smsCode: otp);
      final AuthResult result =
          await _firebaseAuth.signInWithCredential(_authCredential);
      FirebaseUser user = result.user;
      await _updateUserData(user, phoneNumber: phoneNo);
      _userId = user.uid;
      return user.uid;
    } catch (error) {
      print(error.code);
      print(error.message);
      throw HttpException(error.code, error.message);
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      print(googleUser);
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final AuthResult result =
          await _firebaseAuth.signInWithCredential(credential);
      FirebaseUser user = result.user;
      await _updateUserData(user);
      _userId = user.uid;
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

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e;
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      user.sendEmailVerification();
    } catch (e) {
      throw e;
    }
  }

  Future<bool> isEmailVerified() async {
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      return user.isEmailVerified;
    } catch (e) {
      throw e;
    }
  }
}
