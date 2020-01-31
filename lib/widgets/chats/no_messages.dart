import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/styles/colors.dart';

class NoMessages extends StatelessWidget {
  const NoMessages({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "start a conversation.",
            style: TextStyle(color: MyColors.grey, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
