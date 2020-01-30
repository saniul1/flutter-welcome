import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message(this.authorID, this.timestamp, this.value, this.type,
      [this.outgoing = false]);

  final String authorID;
  final Timestamp timestamp;
  final String value;
  final String type;
  final bool outgoing; // True if this message was sent by the current user
}

class Messages {
  final List<Message> messages;
  final List participants;
  final DocumentReference reference;

  Messages({this.messages, this.participants, this.reference});

  factory Messages.fromMap(
      Map<String, dynamic> map, DocumentReference reference, String id) {
    map['messages'].map((data) => print(data[0]['value']));
    final List msgs = map['messages'] ?? [];
    final List<Message> messages = msgs.map((data) {
      return Message(
        data['author'],
        data['timestamp'],
        data['value'],
        data['type'],
        data['author'] == id,
      );
    }).toList();
    return Messages(
      messages: messages,
      participants: map['participants'] ?? [],
      reference: reference,
    );
  }
}
