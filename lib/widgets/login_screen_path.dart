import 'package:flutter/material.dart';

class LoginPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.deepOrange[100];
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.20);
    path.quadraticBezierTo(size.width * 0.13, size.height * 0.22,
        size.width * 0.20, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.5,
        size.width * 0.70, size.height * 0.3);
    path.quadraticBezierTo(
        size.width * 0.90, size.height * 0.15, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
