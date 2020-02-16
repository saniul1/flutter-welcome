import 'package:cloud_firestore/cloud_firestore.dart';

class Friend {
  final String id;
  final Timestamp since;
  final String initiator;
  Friend({this.id, this.since, this.initiator});
}

class Friends {
  final List<Friend> friendsList;
  Friends(this.friendsList);

  factory Friends.fromDocumentSnapShot(QuerySnapshot snapshot) {
    List<Friend> friends = [];
    snapshot.documents.forEach((data) {
      final friend = Friend(
          id: data['id'],
          initiator: data['initiator'],
          since: data['createdAt']);
      friends.add(friend);
    });
    return Friends(friends);
  }
}
