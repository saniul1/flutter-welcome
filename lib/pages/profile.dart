import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_fire_plus/services/auth.dart';
import 'package:flutter_fire_plus/styles/colors.dart';
import 'package:flutter_fire_plus/models/user.dart';
import 'package:flutter_fire_plus/utils/helper.dart';
import 'package:flutter_fire_plus/widgets/profile_header.dart';
import 'package:flutter_fire_plus/pages/enter_otp.dart';
import 'package:flutter_fire_plus/widgets/row_item.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/home-page';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _id;
  User _user;

  final isSelf = true;
  final isFriend = false;

  Future<User> _getUserData(String id) async {
    if (_user != null) return _user;
    final documentSnapshot =
        await Firestore.instance.collection("users").document(id).get();
    final user = User.fromSnapshot(documentSnapshot);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    final _id = Provider.of<Auth>(context, listen: false).userId;
    final _headerSize = MediaQuery.of(context).size.height * 0.5 <= 320
        ? MediaQuery.of(context).size.height * 0.5
        : 320;
    // Future.delayed(Duration(seconds: 2), () async {
    //   // Provider.of<Auth>(context, listen: false).signOut();
    //   final u = await _getUserData(_id);
    //   print(u);
    // });
    final Future<bool> isEmailVerified =
        Provider.of<Auth>(context, listen: false).isEmailVerified();
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_id),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.exit_to_app),
      //       onPressed: () => _confirmLogout(context),
      //     )
      //   ],
      // ),
      body: FutureBuilder(
        future: _getUserData(_id),
        builder: (context, snapshot) {
          _user = snapshot.data;
          if (_user == null) {
            return LinearProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            );
          } else {
            return Column(
              children: <Widget>[
                Header(
                    user: _user,
                    size: _headerSize,
                    isFriend: isFriend,
                    isSelf: isSelf),
                Container(
                  height: MediaQuery.of(context).size.height - _headerSize,
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height - _headerSize,
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
                                      _user.bio ?? 'Tell us about your self',
                                      style: TextStyle(color: MyColors.grey),
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                              ),
                              buildDivider(),
                              buildEmailRow(context, isEmailVerified),
                              buildDivider(),
                              buildPhoneRow(context),
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
                                  await Provider.of<Auth>(context,
                                          listen: false)
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
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildEmailRow(BuildContext context, Future<bool> isEmailVerified) {
    return BodyRowBar(
      text: _user.email ?? 'Not added yet',
      suffix: _user.email == null
          ? FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Text('Add Email Address.'),
              onPressed: () => _addEmail(context),
            )
          : !isSelf
              ? null
              : FutureBuilder(
                  future: isEmailVerified,
                  builder: (context, value) {
                    if (value.connectionState == ConnectionState.waiting) {
                      return Text('');
                    } else {
                      if (value.data != null && value.data) {
                        return Row(
                          children: <Widget>[
                            Icon(
                              Icons.done,
                              size: 18,
                            ),
                            Text('Verified')
                          ],
                        );
                      } else {
                        return FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          child: Text('Verify'),
                          onPressed: () async {
                            try {
                              await Provider.of<Auth>(context, listen: false)
                                  .sendEmailVerification();
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
                        );
                      }
                    }
                  },
                ),
    );
  }

  Widget buildPhoneRow(BuildContext context) {
    return BodyRowBar(
      // text: '+919876543210',
      text: _user.phoneNumber ?? 'Not added yet',
      suffix: _user.phoneNumber == null
          ? FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text('Verify'),
                      onPressed: () async {
                        await Provider.of<Auth>(
                          context,
                          listen: false,
                        ).verifyPhone(
                          _user.phoneNumber,
                          onSuccess: (String verificationId,
                              [int forceResendingToken]) async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => EnterOtp(
                                  id: verificationId,
                                  phoneNumber: _user.phoneNumber,
                                  isExistingUser: true,
                                ),
                              ),
                            );
                          },
                          onFailed: (error) => print('error: ${error.message}'),
                          onTimeout: (verificationId) =>
                              print('Verification timed out.'),
                        );
                      },
                    ),
    );
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
}
