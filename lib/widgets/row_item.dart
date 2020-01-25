import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/styles/colors.dart';

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
                style: TextStyle(color: MyColors.grey, fontSize: 17),
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
