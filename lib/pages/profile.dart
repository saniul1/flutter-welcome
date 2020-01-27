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

class _ProfilePageState extends State<ProfilePage> {
  var _isSelf;
  final isFriend = false;

  var _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    if (widget.id == null) {
      _isSelf = true;
      Provider.of<UserData>(context, listen: false)
          .fetchAndSetUserData()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      _isSelf = false;
      Provider.of<UserData>(context, listen: false)
          .getUserData(widget.id)
          .then((user) {
        Provider.of<UserData>(context, listen: false)
            .setUserData(user)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }

    super.initState();
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
                      isFriend: isFriend,
                      isSelf: _isSelf,
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
                                    isSelf: _isSelf,
                                  ),
                                  buildBodyRowDivider(),
                                  PhoneRow(
                                    isSelf: _isSelf,
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
                              if (user.email != null && _isSelf)
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
                              else if (_isSelf)
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
