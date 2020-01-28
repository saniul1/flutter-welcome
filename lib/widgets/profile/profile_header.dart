import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_fire_plus/services/user_data.dart';
import 'package:flutter_fire_plus/utils/profile_helper.dart';

import 'package:flutter_fire_plus/pages/edit_profile.dart';
import 'package:flutter_fire_plus/pages/chat_screen.dart';
import 'package:flutter_fire_plus/pages/friend_list.dart';
import 'package:flutter_fire_plus/widgets/box_button.dart';

class Header extends StatelessWidget {
  const Header({
    Key key,
    @required this.size,
    @required this.isSelf,
  });

  final bool isSelf;
  final double size;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context).user;
    final isFriend = Provider.of<UserData>(context).isFriend;
    return Container(
      height: size,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                image: DecorationImage(
                  alignment: Alignment(0, 0),
                  image: user.imageURL == null
                      ? AssetImage('assets/images/avatar1.png')
                      : NetworkImage(user.imageURL),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor.withAlpha(235),
                    BlendMode.srcATop,
                  ),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: user.imageURL == null
                            ? AssetImage('assets/images/avatar1.png')
                            : NetworkImage(user.imageURL),
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                    Text(
                      user.name ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .display1
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              isFriend || isSelf
                  ? BoxButton(
                      label: 'Friends',
                      icon: Icons.people,
                      callback: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FriendList(
                              id: user.id,
                            ),
                          ),
                        );
                      },
                    )
                  : BoxButton(
                      label: 'Add Friend',
                      icon: Icons.person_add,
                      callback: () async {
                        await Provider.of<UserData>(context, listen: false)
                            .addToFriendList(user.id);
                        Provider.of<UserData>(context, listen: false)
                            .checkFriend(user.id);
                      },
                    ),
              VerticalDivider(
                width: 2,
              ),
              isSelf
                  ? BoxButton(
                      label: 'Edit',
                      icon: Icons.edit,
                      callback: () => _openEditPage(context),
                    )
                  : BoxButton(
                      label: 'Chat',
                      icon: Icons.chat,
                      callback: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ChatScreen()),
                        );
                      },
                    ),
              VerticalDivider(
                width: 2,
              ),
              if (isSelf)
                BoxButton(
                  label: 'Sign out',
                  icon: Icons.exit_to_app,
                  callback: () => confirmLogout(context),
                ),
            ],
          ),
          buildBodyRowDivider(),
        ],
      ),
    );
  }

  void _openEditPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return EditProfilePage();
        },
        fullscreenDialog: true,
      ),
    );
  }
}
