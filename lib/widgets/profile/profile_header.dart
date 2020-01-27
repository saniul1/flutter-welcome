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
    @required this.isFriend,
    @required this.isSelf,
  });

  final bool isFriend;
  final bool isSelf;
  final double size;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context).user;
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
                  image: NetworkImage(user.imageURL ??
                      'https://images.squarespace-cdn.com/content/v1/5c8eba949b7d157921bba3e4/1558254396295-BDGVZTP3I9BS9V7QN2XS/ke17ZwdGBToddI8pDm48kAGx3IFADtt9koaOuly55F57gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z4YTzHvnKhyp6Da-NYroOW3ZGjoBKy3azqku80C789l0pTKqSDRwmMK43IUI3HojJX_iGOyvGz0VEAhzFdMwNTUP3iYIRpjRWHZRVGJwIQ0nA/The+Humans+Being+Project-Myanmar-Yangon-Part+II-22.jpg?format=2500w'),
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
                        backgroundImage: NetworkImage(user.imageURL ??
                            'https://images.squarespace-cdn.com/content/v1/5c8eba949b7d157921bba3e4/1558254396295-BDGVZTP3I9BS9V7QN2XS/ke17ZwdGBToddI8pDm48kAGx3IFADtt9koaOuly55F57gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z4YTzHvnKhyp6Da-NYroOW3ZGjoBKy3azqku80C789l0pTKqSDRwmMK43IUI3HojJX_iGOyvGz0VEAhzFdMwNTUP3iYIRpjRWHZRVGJwIQ0nA/The+Humans+Being+Project-Myanmar-Yangon-Part+II-22.jpg?format=2500w'),
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
                            builder: (_) => FriendList(),
                          ),
                        );
                      },
                    )
                  : BoxButton(
                      label: 'Add Friend',
                      icon: Icons.person_add,
                      callback: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FriendList(),
                          ),
                        );
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
