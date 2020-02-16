import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/mock/data.dart';
import 'package:flutter_fire_plus/services/auth.dart';
import 'package:flutter_fire_plus/services/user_data.dart';
import 'package:flutter_fire_plus/styles/colors.dart';
import 'package:provider/provider.dart';

class MockApp extends StatefulWidget {
  @override
  _MockAppState createState() => _MockAppState();
}

class _MockAppState extends State<MockApp> {
  var isStarted = false;
  var isDone = false;
  var userCount = 0;
  var successCount = 0;
  var failCount = 0;
  final List<MockUser> users = [];

  void start() {
    setState(() {
      isStarted = true;
    });
    beginToAddUser(context);
  }

  void beginToAddUser(BuildContext context) {
    userData.forEach((data) async {
      final MockUser user = MockUser.fromMap(data);
      users.add(user);
    });

    addUser(users[userCount]);
  }

  Future<void> addUser(MockUser user) async {
    await Future.delayed(Duration(seconds: 1)).then((_) {});
    try {
      await Provider.of<Auth>(context, listen: false)
          .signUp(name: user.name, email: user.email, password: '123456');
      await Provider.of<UserData>(context, listen: false).fetchAndSetUserData();
      final currentUser =
          Provider.of<UserData>(context, listen: false).currentUser;
      await currentUser.reference.updateData({
        'photoURL': user.imageURL,
        'bio': user.bio,
      });
      await Provider.of<Auth>(context, listen: false).signOut();
    } catch (e) {
      print('error ${user.name ?? user.email ?? 'no name and email'}');
      if (userCount < users.length) {
        addUser(users[userCount]);
      }
      failCount++;
      increaseCount();
      return;
    }
    print(user.name ?? user.email);
    increaseCount();
    successCount++;
    if (userCount < users.length) {
      addUser(users[userCount]);
    }
    return;
  }

  void increaseCount() {
    setState(() {
      userCount++;
      if (userData.length == userCount) isDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                userCount.toString(),
                style: TextStyle(color: Colors.white, fontSize: 38),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50,
                width: 100,
                child: RaisedButton(
                  onPressed: isStarted ? null : start,
                  child: isStarted
                      ? isDone
                          ? Text(
                              "Done",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : CircularProgressIndicator()
                      : Text(
                          'Start',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          if (userCount > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Success: $successCount',
                  style: TextStyle(
                    color: MyColors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Failed: $failCount',
                  style: TextStyle(
                    color: MyColors.googleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
