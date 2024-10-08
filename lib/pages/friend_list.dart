import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fire_plus/services/user_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fire_plus/services/auth.dart';
import 'package:flutter_fire_plus/models/user.dart';
import 'package:flutter_fire_plus/widgets/people_list.dart';

class FriendList extends StatelessWidget {
  FriendList({@required this.id, RouteSettings settings});
  final String id;
  @override
  Widget build(BuildContext context) {
    Provider.of<UserData>(context, listen: false).getFriends(id);
    final currentUserFriends = Provider.of<UserData>(context).friends;
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || currentUserFriends == null)
            return LinearProgressIndicator();
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
          if (currentUserFriends != null)
            currentUserFriends.forEach((data) {
              final friend = userList.singleWhere((user) => user.id == data.id);
              if (friend != null) friends.add(friend);
              others.removeWhere((user) => user.id == data.id);
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
