import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/styles/colors.dart';

class LongButton extends StatelessWidget {
  const LongButton({
    Key key,
    @required this.label,
    this.color,
    this.callback,
  }) : super(key: key);

  final String label;
  final Color color;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: callback,
      padding: const EdgeInsets.all(14),
      color: color ?? MyColors.primaryColor,
      textColor: Colors.white,
      textTheme: ButtonTextTheme.normal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      ),
    );
  }
}
