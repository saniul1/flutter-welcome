import 'package:flutter/material.dart';
import 'package:flutter_fire_plus/styles/colors.dart';

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
