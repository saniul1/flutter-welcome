import 'package:flutter/material.dart';

class ArrowClipper extends CustomClipper<Path> {
  ArrowClipper({this.isLeft = true});
  final curve = 12.0;
  final bool isLeft;
  @override
  Path getClip(Size size) {
    var path = Path();
    if (isLeft) {
      path.moveTo(0, 0);
      path.lineTo(curve, curve);
      path.lineTo(curve, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
      path.close();
    } else {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width - curve, size.height - curve);
      path.lineTo(size.width - curve, 0);
      path.lineTo(0, 0);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
