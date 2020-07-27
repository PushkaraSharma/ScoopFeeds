import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
    // TODO: implement getClip
    Path getClip(Size size) {

      var path = new Path();

      path.lineTo(0.0, size.height - 40);

      path.quadraticBezierTo(

          size.width / 4, size.height - 80, size.width / 2, size.height - 40);

      path.quadraticBezierTo(size.width - (size.width / 4), size.height,

          size.width, size.height - 40);

      path.lineTo(size.width, 0.0);

      path.close();

      return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}