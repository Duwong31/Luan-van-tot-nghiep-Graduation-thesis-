import 'package:flutter/material.dart';

class ScreenShadowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double insetTop = 20.0;

    final path = Path();
    path.moveTo(insetTop, 0);
    path.lineTo(size.width - insetTop, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
