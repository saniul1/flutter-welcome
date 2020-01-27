import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fire_plus/pages/auth_screen.dart';
import 'package:flutter_fire_plus/services/user_data.dart';
import 'package:flutter_fire_plus/services/auth.dart';

Divider buildBodyRowDivider({val = 0.0, color = Colors.grey}) {
  return Divider(height: val, color: color);
}

Future<void> confirmLogout(BuildContext context) async {
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

Future<void> addEmail(BuildContext context) async {
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
        final user = Provider.of<UserData>(context).user;
        await user.reference.updateData({'email': _email});
        await Provider.of<UserData>(context, listen: false)
            .fetchAndSetUserData();
      } catch (e) {
        print(e);
      }
    }
  });
}
