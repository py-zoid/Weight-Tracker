import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.deepOrange[100];
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.25);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.4,
        size.width * 0.45, size.height * 0.25);
    path.quadraticBezierTo(
        size.width * 0.7, size.height * 0.12, size.width, size.height * 0.15);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    path.moveTo(size.width * 0.45, size.height * 0.60);
    path.quadraticBezierTo(size.width * 0.65, size.height * 0.75,
        size.width * 0.55, size.height * 0.90);
    path.quadraticBezierTo(size.width * 0.50, size.height * 0.93,
        size.width * 0.45, size.height * 0.90);
    path.quadraticBezierTo(size.width * 0.55, size.height * 0.75,
        size.width * 0.45, size.height * 0.60);
//    path.quadraticBezierTo(
//        size.width*0.50, size.height*0.57, size.width*0.55, size.height * 0.60);
//    path.lineTo(size.width*0.75, size.height * 0.65);

    path.moveTo(0, size.height * 0.91);
    path.lineTo(size.width * 0.44, size.height * 0.91);
    path.quadraticBezierTo(size.width * 0.50, size.height * 0.95,
        size.width * 0.56, size.height * 0.91);
    path.lineTo(size.width, size.height * 0.91);
    path.quadraticBezierTo(
        size.width * 0.50, size.height * 1.05, 0, size.height * 0.91);

    path.moveTo(size.width * 0.45, size.height * 0.62);
    path.lineTo(size.width * 0.44, size.height * 0.89);
    path.lineTo(size.width * 0.46, size.height * 0.87);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
