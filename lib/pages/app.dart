import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/pages/auth_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fire_plus/services/auth.dart';

class MyHomePage extends StatelessWidget {
  static const routeName = '/home-page';
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

  @override
  Widget build(BuildContext context) {
    final id = Provider.of<Auth>(context, listen: false).userId;
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Fire+'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => _confirmLogout(context),
            )
          ],
        ),
        body: FutureBuilder(
          future: getUser(id),
          builder: (context, snapshot) {
            final User user = snapshot.data;
            return user != null
                ? SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(user.imageURL ??
                                'https://via.placeholder.com/150'),
                            backgroundColor: Colors.grey[200],
                          ),
                        ),
                        Center(
                          child: Text(
                            user.name ?? '',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              user.email ?? '',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black45),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              user.phoneNumber ?? '',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black45),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              user.createdOn.toDate().toString() ?? '',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black45),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              user.lastSeen.toDate().toString() ?? '',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black45),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : LinearProgressIndicator();
          },
        ));
  }
}

Future<User> getUser(String id) async {
  final documentSnapshot =
      await Firestore.instance.collection("users").document(id).get();
  final user = User.fromSnapshot(documentSnapshot);
  return user;
}

class User {
  final String name;
  final String email;
  final String phoneNumber;
  final Timestamp createdOn;
  final Timestamp lastSeen;
  final String imageURL;
  final DocumentReference reference;

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['displayName'],
        email = map['email'],
        imageURL = map['photoURL'],
        phoneNumber = map['phoneNumber'],
        createdOn = map['createdOn'],
        lastSeen = map['lastSeen'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
