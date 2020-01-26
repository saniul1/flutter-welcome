import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/styles/colors.dart';

SizedBox buildSizedBox({val = 16}) {
  return SizedBox(
    height: double.parse(val.toString()),
  );
}

Divider buildDivider({val = 0.0, color = Colors.grey}) {
  return Divider(height: val, color: color);
}

Future buildLoadingDialog(BuildContext context,
    {String msg = 'Authenticating...'}) {
  // Future.delayed(Duration(seconds: 10)).then((_) {
  //   Navigator.pop(context);
  // });
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: AlertDialog(
          backgroundColor: MyColors.secondaryColor,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              CircularProgressIndicator(
                backgroundColor: MyColors.secondaryColor,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  msg,
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('An Error Occurred!'),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text('Okay'),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}
