import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String bio;
  final String email;
  final String phoneNumber;
  final Timestamp createdOn;
  final List logInData;
  final List friends;
  final String imageURL;
  final bool isPhoneVerified;
  final DocumentReference reference;

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : id = map['uid'],
        name = map['displayName'] ?? '',
        bio = map['bio'] ?? '',
        email = map['email'],
        imageURL = map['photoURL'],
        phoneNumber = map['phoneNumber'],
        isPhoneVerified = map['isPhoneVerified'],
        createdOn = map['createdOn'],
        logInData = map['lastSeen'],
        friends = map['friends'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Timestamp get lastSeen {
    return logInData.reversed.toList()[0];
  }
}
