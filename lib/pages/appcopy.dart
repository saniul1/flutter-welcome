import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/pages/ChatScreen.dart';
import 'package:flutter_fire_plus/pages/friend_list.dart';
import 'package:intl/intl.dart';
import 'package:flutter_fire_plus/pages/auth_screen.dart';
import 'package:flutter_fire_plus/styles/colors.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fire_plus/services/auth.dart';

class MyHomePageTest extends StatefulWidget {
  static const routeName = '/home-page-test';

  @override
  _MyHomePageTestState createState() {
    return _MyHomePageTestState();
  }
}

class _MyHomePageTestState extends State<MyHomePageTest> {
  final List<String> images = [
    'https://images.squarespace-cdn.com/content/v1/5c8eba949b7d157921bba3e4/1558254396295-BDGVZTP3I9BS9V7QN2XS/ke17ZwdGBToddI8pDm48kAGx3IFADtt9koaOuly55F57gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z4YTzHvnKhyp6Da-NYroOW3ZGjoBKy3azqku80C789l0pTKqSDRwmMK43IUI3HojJX_iGOyvGz0VEAhzFdMwNTUP3iYIRpjRWHZRVGJwIQ0nA/The+Humans+Being+Project-Myanmar-Yangon-Part+II-22.jpg?format=2500w'
  ];

  final isSelf = false;
  final isFriend = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 275,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                image: DecorationImage(
                  alignment: Alignment(0, 0),
                  image: NetworkImage(images[0]),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor.withAlpha(235),
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
                        backgroundImage: NetworkImage(images[0]),
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                  ),
                  Text(
                    "Max Doe",
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
                isFriend
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
                              MaterialPageRoute(builder: (_) => ChatScreen()));
                        },
                      ),
                VerticalDivider(
                  width: 2,
                ),
                BoxButton(
                  label: 'Sign out',
                  icon: Icons.exit_to_app,
                  callback: () {},
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
              text: 'maxdoe@mail.com',
              suffix: true
                  ? FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text('Verify'),
                      onPressed: () {},
                    )
                  : Row(
                      children: <Widget>[
                        Icon(
                          Icons.done,
                          size: 18,
                        ),
                        Text('Verified')
                      ],
                    ),
            ),
            buildDivider(),
            BodyRowBar(
              // text: '+919876543210',
              text: '',
              suffix: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: Text('Add Mobile No.'),
                onPressed: () {},
              ),
            ),
            buildDivider(),
            BodyRowBar(
              text: 'Created On',
              suffix: Text(
                  DateFormat('MM/dd/yyyy - hh:mm a').format(DateTime.now())),
            ),
            buildDivider(),
            BodyRowBar(
              text: 'Last Visited',
              suffix: Text(
                  DateFormat('MM/dd/yyyy - hh:mm a').format(DateTime.now())),
            ),
          ],
        ),
      ),
    );
  }
}

class BodyRowBar extends StatelessWidget {
  const BodyRowBar({
    @required this.text,
    this.suffix,
    Key key,
  }) : super(key: key);

  final String text;
  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.lightGrey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20,
              ),
              child: Text(
                text,
                // style: TextStyle(color: MyColors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: suffix,
          ),
        ],
      ),
    );
  }
}

Divider buildDivider({val = 0.0}) {
  return Divider(
    height: val,
    color: MyColors.grey,
  );
}

class BoxButton extends StatelessWidget {
  const BoxButton({
    @required this.icon,
    @required this.label,
    this.callback,
    Key key,
  }) : super(key: key);
  final IconData icon;
  final String label;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: callback,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Icon(
                icon,
                color: MyColors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: MyColors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//   Widget _buildBody(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: Firestore.instance.collection('baby').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return LinearProgressIndicator();

//         return _buildList(context, snapshot.data.documents);
//       },
//     );
//   }

//   Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
//     return ListView(
//       padding: const EdgeInsets.only(top: 20.0),
//       children: snapshot.map((data) => _buildListItem(context, data)).toList(),
//     );
//   }

//   Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
//     final record = Record.fromSnapshot(data);

//     return Padding(
//       key: ValueKey(record.name),
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(5.0),
//         ),
//         child: ListTile(
//           title: Text(record.name),
//           trailing: Text(record.votes.toString()),
//           onTap: () =>
//               record.reference.updateData({'votes': FieldValue.increment(1)}),
//         ),
//       ),
//     );
//   }
// }

// class Record {
//   final String name;
//   final int votes;
//   final DocumentReference reference;

//   Record.fromMap(Map<String, dynamic> map, {this.reference})
//       : assert(map['name'] != null),
//         assert(map['votes'] != null),
//         name = map['name'],
//         votes = map['votes'];

//   Record.fromSnapshot(DocumentSnapshot snapshot)
//       : this.fromMap(snapshot.data, reference: snapshot.reference);

//   @override
//   String toString() => "Record<$name:$votes>";
// }
