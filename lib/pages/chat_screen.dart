import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/models/messages.dart';
import 'package:flutter_fire_plus/services/auth.dart';
import 'package:flutter_fire_plus/services/chats.dart';
import 'package:flutter_fire_plus/widgets/chats/input_field.dart';
import 'package:flutter_fire_plus/widgets/chats/messages_tree.dart';
import 'package:flutter_fire_plus/widgets/chats/no_messages.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    goToBottom();
    super.initState();
  }

  void goToBottom() {
    print('goToBottom()');
    Future.delayed(Duration(milliseconds: 500)).then(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _id = Provider.of<Auth>(context, listen: false).userId;
    final chatRoom = Provider.of<Chats>(context, listen: false).chatroom;
    final name = chatRoom == null ? [] : chatRoom.displayName.split(" ");

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        // backgroundColor: MyColors.primaryColor,
        // leading: Icon(Icons.keyboard_backspace),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.person_add),
        //     onPressed: () {},
        //   )
        // ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(name[0]),
            if (name.length > 1)
              Text(
                name[1],
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection('chats')
                    .document(chatRoom.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();
                  final document = snapshot.data;
                  final messages =
                      Messages.fromMap(document.data, document.reference, _id)
                          .messages;
                  if (messages.length == 0) return NoMessages();
                  return MessagesTree(
                    messages: messages,
                    goToBottom: goToBottom,
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InputField(
              goToBottom: goToBottom,
            ),
          ),
        ],
      ),
    );
  }
}
