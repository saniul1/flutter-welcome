import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/models/friends.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fire_plus/services/auth.dart';
import 'package:flutter_fire_plus/services/user_data.dart';
import 'package:flutter_fire_plus/models/user.dart';

import 'package:flutter_fire_plus/utils/profile_helper.dart';
import 'package:flutter_fire_plus/styles/colors.dart';
import 'package:flutter_fire_plus/pages/profile.dart';

class PeopleList extends StatelessWidget {
  const PeopleList({
    Key key,
    @required this.category,
    this.people,
  }) : super(key: key);

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
                  backgroundImage: user.imageURL == null
                      ? AssetImage('assets/images/avatar1.png')
                      : CachedNetworkImageProvider(user.imageURL),
                  backgroundColor: Colors.grey[200],
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
                              ? FriendCount(id: user.id)
                              : IconButton(
                                  icon: Icon(Icons.person_add),
                                  onPressed: () async {
                                    await Provider.of<UserData>(context,
                                            listen: false)
                                        .addToFriendList(user.id);
                                    showFriendConfirmation(context, user.name);
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

class FriendCount extends StatelessWidget {
  FriendCount({this.id});
  final String id;
  // await Provider.of<UserData>(context, listen: false).getFriends(id)
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: MyColors.lightGrey,
        shape: BoxShape.circle,
      ),
      child: Text('count'),
    );
  }
}
