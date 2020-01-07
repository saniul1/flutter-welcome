import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/styles/colors.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(children: <Widget>[
        Expanded(
          child: Divider(
            color: MyColors.primaryColor,
            thickness: 1,
          ),
        ),
        SizedBox(
          child: Text(
            "OR",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          child: Divider(
            color: MyColors.primaryColor,
            thickness: 1,
          ),
        ),
      ]),
    );
  }
}
