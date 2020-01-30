import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_fire_plus/models/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fire_plus/models/user.dart';
import 'package:flutter_fire_plus/services/auth.dart';

class SelectedChatroom {
  SelectedChatroom(this.id, this.displayName);

  final String id;
  final String displayName;
}

class Chatroom {
  Chatroom(this.participants, [this.messages]);

  final List<User> participants;
  final List<Message> messages;
}

class Chats with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  SelectedChatroom _chatroom;

  SelectedChatroom get chatroom {
    return _chatroom;
  }

  Future<SelectedChatroom> startChatroomForUser(User user) async {
    final currentUser = await Auth.getCurrentUser();
    final documentSnapshot =
        await _db.collection('users').document(currentUser.uid).get();
    final currentUserData = User.fromSnapshot(documentSnapshot);
    QuerySnapshot queryResults = await _db
        .collection("chats")
        .where("participants", arrayContains: user.id)
        .getDocuments();
    DocumentSnapshot roomSnapshot = queryResults.documents.firstWhere((room) {
      return room.data["participants"].contains(currentUserData.id);
    }, orElse: () => null);
    if (roomSnapshot != null) {
      _chatroom = SelectedChatroom(roomSnapshot.documentID, user.name);
      return _chatroom;
    } else {
      Map<String, dynamic> chatroomMap = Map<String, dynamic>();
      chatroomMap["messages"] = List<String>(0);
      chatroomMap["participants"] = [currentUserData.id, user.id];
      DocumentReference reference =
          await _db.collection("chats").add(chatroomMap);
      DocumentSnapshot chatroomSnapshot = await reference.get();
      _chatroom = SelectedChatroom(chatroomSnapshot.documentID, user.name);
      return _chatroom;
    }
  }

  Future<bool> sendMessageToChatroom(
      {String chatroomId, String message, String type}) async {
    try {
      final currentUser = await Auth.getCurrentUser();
      DocumentReference chatroomRef =
          _db.collection("chats").document(chatroomId);
      Map<String, dynamic> serializedMessage = {
        "author": currentUser.uid,
        "timestamp": DateTime.now(),
        "value": message,
        "type": type
      };
      chatroomRef.updateData({
        "messages": FieldValue.arrayUnion([serializedMessage])
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
