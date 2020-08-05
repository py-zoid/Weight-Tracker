import 'package:flutter/material.dart';

class PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.orange;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(size.width * 0.40, size.height * 0.75);
    path.lineTo(size.width * 0.60, size.height * 0.76);
    path.lineTo(size.width * 0.40, size.height * 0.77);
    path.lineTo(size.width * 0.40, size.height * 0.75);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
