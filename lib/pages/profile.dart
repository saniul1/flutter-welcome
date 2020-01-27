import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:flutter_fire_plus/services/user_data.dart';
import 'package:flutter_fire_plus/services/auth.dart';

import 'package:flutter_fire_plus/utils/profile_helper.dart';
import 'package:flutter_fire_plus/styles/colors.dart';

import 'package:flutter_fire_plus/widgets/profile/profile_header.dart';
import 'package:flutter_fire_plus/widgets/profile/row_item.dart';
import 'package:flutter_fire_plus/widgets/profile/email_row.dart';
import 'package:flutter_fire_plus/widgets/profile/phone_row.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/home-page';

  ProfilePage({this.id});

  final String id;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
  var isSelf;
  var isFriend = false;
  var _isLoading = false;
  bool isBackButtonActivated = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _isLoading = true;
    if (widget.id == null) {
      isSelf = true;
      Provider.of<UserData>(context, listen: false)
          .fetchAndSetUserData()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      isSelf = Provider.of<Auth>(context, listen: false).userId == widget.id;
      Provider.of<UserData>(context, listen: false)
          .getUserData(widget.id)
          .then((user) {
        Provider.of<UserData>(context, listen: false)
            .checkFriend(widget.id)
            .then((value) {
          Provider.of<UserData>(context, listen: false)
              .setUserData(user)
              .then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        });
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didPopRoute() {
    bool override;
    if (isBackButtonActivated)
      override = false;
    else
      override = true;
    return new Future<bool>.value(override);
  }

  @override
  Widget build(BuildContext context) {
    final headerSize = MediaQuery.of(context).size.height * 0.5 <= 320
        ? MediaQuery.of(context).size.height * 0.5
        : 320;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(''),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.exit_to_app),
      //       onPressed: () => confirmLogout(context),
      //     )
      //   ],
      // ),
      body: _isLoading
          ? LinearProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            )
          : Builder(
              builder: (ctx) {
                final user = Provider.of<UserData>(context).user;
                return Column(
                  children: <Widget>[
                    Header(
                      size: headerSize,
                      isSelf: isSelf,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - headerSize,
                      child: SingleChildScrollView(
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height - headerSize,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    color: MyColors.lightGrey,
                                    constraints: BoxConstraints(minHeight: 100),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          user.bio ?? 'Tell us about your self',
                                          style:
                                              TextStyle(color: MyColors.grey),
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                  buildBodyRowDivider(),
                                  EmailRow(
                                    isSelf: isSelf,
                                  ),
                                  buildBodyRowDivider(),
                                  PhoneRow(
                                    isSelf: isSelf,
                                  ),
                                  buildBodyRowDivider(),
                                  BodyRowItem(
                                    text: 'Created On',
                                    suffix: Text(
                                        DateFormat('MM/dd/yyyy - hh:mm a')
                                            .format(user.createdOn.toDate())),
                                  ),
                                  buildBodyRowDivider(),
                                  BodyRowItem(
                                    text: 'Last Visited',
                                    suffix: Text(
                                        DateFormat('MM/dd/yyyy - hh:mm a')
                                            .format(user.lastSeen.toDate())),
                                  ),
                                ],
                              ),
                              if (user.email != null && isSelf)
                                RaisedButton(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  elevation: 0,
                                  color: Colors.grey[200],
                                  onPressed: () async {
                                    try {
                                      await Provider.of<Auth>(context,
                                              listen: false)
                                          .resetPassword(user.email);
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Email Send! check your inbox.'),
                                          action: SnackBarAction(
                                            label: 'Dismiss',
                                            onPressed: () {},
                                          ),
                                        ),
                                      );
                                    } catch (error) {
                                      print(error);
                                    }
                                  },
                                  child: Text('Forgot Password? Reset'),
                                )
                              else if (isSelf)
                                RaisedButton(
                                  onPressed: () => addEmail(context),
                                  child: Text('No Email found! Add'),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  color: Colors.grey[200],
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
