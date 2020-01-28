import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fire_plus/services/auth.dart';
import 'package:flutter_fire_plus/models/user.dart';
import 'package:flutter_fire_plus/widgets/people_list.dart';

class FriendList extends StatelessWidget {
  FriendList({@required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          final documents = snapshot.data.documents;
          final _signID = Provider.of<Auth>(context).userId;
          final List<User> userList = [];
          User currentUser;
          documents.forEach((data) {
            final _user = User.fromSnapshot(data);
            userList.add(_user);
            if (_user.id == id) currentUser = _user;
          });
          final List<User> friends = [];
          final List<User> others = [...userList];
          others.removeWhere((user) => user.id == _signID || user.id == id);
          if (currentUser.friends != null)
            currentUser.friends.forEach((friendId) {
              final friend =
                  userList.singleWhere((user) => user.id == friendId);
              if (friend != null) friends.add(friend);
              others.removeWhere((user) => user.id == friendId);
            });
          return Column(
            children: <Widget>[
              PeopleList(
                people: friends,
                category: '${currentUser.name}\'s Friends',
              ),
              PeopleList(
                people: others,
                category: 'Make Friends',
              ),
            ],
          );
        },
      ),
      // body: PeopleList(images: images),
    );
  }
}
