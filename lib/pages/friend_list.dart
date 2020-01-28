import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fire_plus/models/user.dart';
import 'package:flutter_fire_plus/pages/profile.dart';
import 'package:flutter_fire_plus/services/auth.dart';
import 'package:flutter_fire_plus/services/user_data.dart';
import 'package:flutter_fire_plus/styles/colors.dart';
import 'package:provider/provider.dart';

class FriendList extends StatelessWidget {
  FriendList({@required this.id});
  final String id;
  final List<String> images = [
    'https://images.squarespace-cdn.com/content/v1/5c8eba949b7d157921bba3e4/1558254396295-BDGVZTP3I9BS9V7QN2XS/ke17ZwdGBToddI8pDm48kAGx3IFADtt9koaOuly55F57gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z4YTzHvnKhyp6Da-NYroOW3ZGjoBKy3azqku80C789l0pTKqSDRwmMK43IUI3HojJX_iGOyvGz0VEAhzFdMwNTUP3iYIRpjRWHZRVGJwIQ0nA/The+Humans+Being+Project-Myanmar-Yangon-Part+II-22.jpg?format=2500w'
  ];
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
                images: images,
                people: friends,
                category: '${currentUser.name}\'s Friends',
              ),
              PeopleList(
                images: images,
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

class PeopleList extends StatelessWidget {
  const PeopleList({
    Key key,
    @required this.images,
    this.category,
    this.people,
  }) : super(key: key);

  final List<String> images;
  final String category;
  final List<User> people;

  @override
  Widget build(BuildContext context) {
    final _id = Provider.of<Auth>(context).userId;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(category),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildFriendCount(people.length.toString()),
                ),
              ],
            ),
            ...people.map((user) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => ProfilePage(
                        id: user.id,
                      ),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(images[0]),
                ),
                title: Text(user.name),
                trailing: FutureBuilder(
                    future: Provider.of<UserData>(context, listen: false)
                        .checkIfFriendFromServer(user.id),
                    builder: (context, snapshot) {
                      final isFriend = snapshot.data;
                      return isFriend == null
                          ? SizedBox()
                          : isFriend || user.id == _id
                              ? buildFriendCount(
                                  user.friends != null
                                      ? user.friends.length.toString()
                                      : '0',
                                )
                              : IconButton(
                                  icon: Icon(Icons.person_add),
                                  onPressed: () async {
                                    await Provider.of<UserData>(context,
                                            listen: false)
                                        .addToFriendList(user.id);
                                  },
                                );
                    }),
              );
            }),
            if (people.length == 0)
              ListTile(
                title: Text(
                  'There\'s no one on the list.',
                  style: TextStyle(color: MyColors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Container buildFriendCount(String count) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: MyColors.lightGrey,
        shape: BoxShape.circle,
      ),
      child: Text(count),
    );
  }
}
