import 'package:flutter/material.dart';

class LongFlatButton extends StatelessWidget {
  const LongFlatButton({Key key, @required this.label, this.callback})
      : super(key: key);

  final String label;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: callback,
      padding: EdgeInsets.all(14),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
