import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/pages/enter_otp.dart';
import 'package:flutter_fire_plus/widgets/box_button.dart';
import 'package:flutter_fire_plus/widgets/row_item.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:flutter_fire_plus/pages/auth_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fire_plus/services/auth.dart';
import 'package:flutter_fire_plus/styles/colors.dart';

import 'package:flutter_fire_plus/pages/ChatScreen.dart';
import 'package:flutter_fire_plus/pages/friend_list.dart';

class User {
  final String name;
  final String email;
  final String phoneNumber;
  final Timestamp createdOn;
  final List logInData;
  final String imageURL;
  final bool isPhoneVerified;
  final DocumentReference reference;

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['displayName'],
        email = map['email'],
        imageURL = map['photoURL'],
        phoneNumber = map['phoneNumber'],
        isPhoneVerified = map['isPhoneVerified'],
        createdOn = map['createdOn'],
        logInData = map['lastSeen'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Timestamp get lastSeen {
    return logInData.reversed.toList()[0];
  }
}

class MyHomePage extends StatefulWidget {
  static const routeName = '/home-page';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _id;
  User _user;

  final isSelf = true;

  final isFriend = false;

  Future<void> _confirmLogout(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to log out and go back to log in page.'),
        actions: <Widget>[
          FlatButton(
            child: Text('yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          )
        ],
      ),
    ).then((isConfirmed) async {
      if (isConfirmed) {
        try {
          await Provider.of<Auth>(context, listen: false).signOut();
          print('Signed out');
          Navigator.of(context).pushReplacementNamed(Welcome.routeName);
        } catch (e) {
          print(e);
        }
      }
    });
  }

  Future<void> _addEmail(BuildContext context) async {
    final GlobalKey<FormState> _formKey = GlobalKey();
    String _email;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Email'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value.isEmpty || !value.contains('@')) {
                return 'Invalid email!';
              }
              return null;
            },
            onSaved: (value) {
              _email = '$value'.trim();
            },
            decoration: InputDecoration(
              hintText: "Add your email address.",
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('add'),
            onPressed: () {
              if (!_formKey.currentState.validate()) {
                return; // Invalid!
              }
              _formKey.currentState.save();
              Navigator.of(context).pop(true);
            },
          ),
          FlatButton(
            child: Text('cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          )
        ],
      ),
    ).then((isConfirmed) async {
      if (isConfirmed) {
        try {
          print('add Email- $_email');
          await _user.reference.updateData({'email': _email});
          _user = null;
          final User _data = await _getUserData(_id);
          setState(() {
            _user = _data;
          });
        } catch (e) {
          print(e);
        }
      }
    });
  }

  Future<void> _addMobileNo(BuildContext context) async {
    final GlobalKey<FormState> _formKey = GlobalKey();
    String _phoneNumber;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add mobile number'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            autofocus: true,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty || value.length < 10) {
                return 'Invalid phone number!';
              } else if (value.length == 10) {
                return 'don\'t forget add country code!';
              }
              return null;
            },
            onSaved: (value) {
              _phoneNumber = '+$value'.trim();
            },
            decoration: InputDecoration(
              prefix: Text('+'),
              hintText: "Mobile number with country code.",
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('add'),
            onPressed: () {
              if (!_formKey.currentState.validate()) {
                return; // Invalid!
              }
              _formKey.currentState.save();
              Navigator.of(context).pop(true);
            },
          ),
          FlatButton(
            child: Text('cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          )
        ],
      ),
    ).then((isConfirmed) async {
      if (isConfirmed) {
        try {
          print('add No- $_phoneNumber');
          await _user.reference.updateData({'phoneNumber': _phoneNumber});
          _user = null;
          final User _data = await _getUserData(_id);
          setState(() {
            _user = _data;
          });
        } catch (e) {
          print(e);
        }
      }
    });
  }

  Future<User> _getUserData(String id) async {
    if (_user != null) return _user;
    final documentSnapshot =
        await Firestore.instance.collection("users").document(id).get();
    final user = User.fromSnapshot(documentSnapshot);
    return user;
  }

  Divider buildDivider({val = 0.0, color = Colors.grey}) {
    return Divider(height: val, color: color);
  }

  @override
  Widget build(BuildContext context) {
    _id = Provider.of<Auth>(context, listen: false).userId;
    // Future.delayed(Duration(seconds: 2), () async {
    //   // Provider.of<Auth>(context, listen: false).signOut();
    //   final u = await _getUserData(_id);
    //   print(u);
    // });
    final Future<bool> isEmailVerified =
        Provider.of<Auth>(context, listen: false).isEmailVerified();
    return Scaffold(
      appBar: AppBar(
        title: Text(_id),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _confirmLogout(context),
          )
        ],
      ),
      body: FutureBuilder(
        future: _getUserData(_id),
        builder: (context, snapshot) {
          _user = snapshot.data;
          return _user == null
              ? LinearProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                )
              : SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              height: 275,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                image: DecorationImage(
                                  alignment: Alignment(0, 0),
                                  image: NetworkImage(_user.imageURL ??
                                      'https://images.squarespace-cdn.com/content/v1/5c8eba949b7d157921bba3e4/1558254396295-BDGVZTP3I9BS9V7QN2XS/ke17ZwdGBToddI8pDm48kAGx3IFADtt9koaOuly55F57gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z4YTzHvnKhyp6Da-NYroOW3ZGjoBKy3azqku80C789l0pTKqSDRwmMK43IUI3HojJX_iGOyvGz0VEAhzFdMwNTUP3iYIRpjRWHZRVGJwIQ0nA/The+Humans+Being+Project-Myanmar-Yangon-Part+II-22.jpg?format=2500w'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context)
                                        .primaryColor
                                        .withAlpha(235),
                                    BlendMode.srcATop,
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundImage: NetworkImage(_user
                                                .imageURL ??
                                            'https://images.squarespace-cdn.com/content/v1/5c8eba949b7d157921bba3e4/1558254396295-BDGVZTP3I9BS9V7QN2XS/ke17ZwdGBToddI8pDm48kAGx3IFADtt9koaOuly55F57gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z4YTzHvnKhyp6Da-NYroOW3ZGjoBKy3azqku80C789l0pTKqSDRwmMK43IUI3HojJX_iGOyvGz0VEAhzFdMwNTUP3iYIRpjRWHZRVGJwIQ0nA/The+Humans+Being+Project-Myanmar-Yangon-Part+II-22.jpg?format=2500w'),
                                        backgroundColor: Colors.grey[200],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _user.name ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
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
                                        callback: () {},
                                      )
                                    : BoxButton(
                                        label: 'Chat',
                                        icon: Icons.chat,
                                        callback: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) => ChatScreen()),
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
                                    callback: () => _confirmLogout(context),
                                  ),
                              ],
                            ),
                            buildDivider(),
                            Container(
                              color: MyColors.lightGrey,
                              constraints: BoxConstraints(minHeight: 100),
                              child: Center(
                                child: Text(
                                  'Tell us about your self',
                                  style: TextStyle(color: MyColors.grey),
                                  softWrap: true,
                                ),
                              ),
                            ),
                            buildDivider(),
                            BodyRowBar(
                              text: _user.email ?? 'Not added yet',
                              suffix: _user.email == null
                                  ? FlatButton(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      child: Text('Add Email Address.'),
                                      onPressed: () => _addEmail(context),
                                    )
                                  : !isSelf
                                      ? null
                                      : FutureBuilder(
                                          future: isEmailVerified,
                                          builder: (context, value) {
                                            return value.connectionState ==
                                                    ConnectionState.waiting
                                                ? Text('')
                                                : value.data != null &&
                                                        value.data
                                                    ? Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.done,
                                                            size: 18,
                                                          ),
                                                          Text('Verified')
                                                        ],
                                                      )
                                                    : FlatButton(
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        child: Text('Verify'),
                                                        onPressed: () async {
                                                          try {
                                                            await Provider.of<
                                                                        Auth>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .sendEmailVerification();
                                                            Scaffold.of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    'Email Send! check your inbox.'),
                                                                action:
                                                                    SnackBarAction(
                                                                  label:
                                                                      'Dismiss',
                                                                  onPressed:
                                                                      () {},
                                                                ),
                                                              ),
                                                            );
                                                          } catch (error) {
                                                            print(error);
                                                          }
                                                        },
                                                      );
                                          },
                                        ),
                            ),
                            buildDivider(),
                            BodyRowBar(
                              // text: '+919876543210',
                              text: _user.phoneNumber ?? 'Not added yet',
                              suffix: _user.phoneNumber == null
                                  ? FlatButton(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      child: Text('Add Mobile No.'),
                                      onPressed: () => _addMobileNo(context),
                                    )
                                  : !isSelf
                                      ? null
                                      : _user.isPhoneVerified
                                          ? Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.done,
                                                  size: 18,
                                                ),
                                                Text('Verified')
                                              ],
                                            )
                                          : FlatButton(
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              child: Text('Verify'),
                                              onPressed: () async {
                                                await Provider.of<Auth>(
                                                  context,
                                                  listen: false,
                                                ).verifyPhone(
                                                  _user.phoneNumber,
                                                  onSuccess: (String
                                                          verificationId,
                                                      [int
                                                          forceResendingToken]) async {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            EnterOtp(
                                                          id: verificationId,
                                                          phoneNumber:
                                                              _user.phoneNumber,
                                                          isExistingUser: true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  onFailed: (error) => print(
                                                      'error: ${error.message}'),
                                                  onTimeout: (verificationId) =>
                                                      print(
                                                          'Verification timed out.'),
                                                );
                                              },
                                            ),
                            ),
                            buildDivider(),
                            BodyRowBar(
                              text: 'Created On',
                              suffix: Text(DateFormat('MM/dd/yyyy - hh:mm a')
                                  .format(_user.createdOn.toDate())),
                            ),
                            buildDivider(),
                            BodyRowBar(
                              text: 'Last Visited',
                              suffix: Text(DateFormat('MM/dd/yyyy - hh:mm a')
                                  .format(_user.lastSeen.toDate())),
                            ),
                          ],
                        ),
                        if (_user.email != null && isSelf)
                          RaisedButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            elevation: 0,
                            color: Colors.grey[200],
                            onPressed: () async {
                              try {
                                await Provider.of<Auth>(context, listen: false)
                                    .resetPassword(_user.email);
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Email Send! check your inbox.'),
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
                            onPressed: () => _addEmail(context),
                            child: Text('No Email found! Add'),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            color: Colors.grey[200],
                          )
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
