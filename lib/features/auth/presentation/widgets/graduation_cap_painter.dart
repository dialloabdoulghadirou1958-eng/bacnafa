import 'package:flutter/material.dart';

class GraduationCapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    final w = size.width;
    final h = size.height;

    final tasselPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFC4B5FD);

    final shadowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.3);

    final path = Path();
    path.moveTo(w * 0.5, h * 0.08);
    path.quadraticBezierTo(w * 0.75, h * 0.02, w * 0.92, h * 0.14);
    path.lineTo(w * 0.86, h * 0.28);
    path.quadraticBezierTo(w * 0.72, h * 0.18, w * 0.5, h * 0.22);
    path.quadraticBezierTo(w * 0.28, h * 0.18, w * 0.14, h * 0.28);
    path.lineTo(w * 0.08, h * 0.14);
    path.quadraticBezierTo(w * 0.25, h * 0.02, w * 0.5, h * 0.08);
    path.close();
    canvas.drawPath(path, paint);

    final topRect = RRect.fromLTRBR(
      w * 0.3, h * 0.0, w * 0.7, h * 0.1, const Radius.circular(4),
    );
    canvas.drawRRect(topRect, paint);

    final basePath = Path();
    basePath.moveTo(w * 0.5, h * 0.6);
    basePath.quadraticBezierTo(w * 0.25, h * 0.58, w * 0.18, h * 0.68);
    basePath.quadraticBezierTo(w * 0.1, h * 0.78, w * 0.12, h * 0.83);
    basePath.lineTo(w * 0.5, h * 0.98);
    basePath.lineTo(w * 0.88, h * 0.83);
    basePath.quadraticBezierTo(w * 0.9, h * 0.78, w * 0.82, h * 0.68);
    basePath.quadraticBezierTo(w * 0.75, h * 0.58, w * 0.5, h * 0.6);
    basePath.close();
    canvas.drawPath(basePath, shadowPaint);

    final mainBodyPath = Path();
    mainBodyPath.moveTo(w * 0.5, h * 0.68);
    mainBodyPath.quadraticBezierTo(w * 0.28, h * 0.65, w * 0.22, h * 0.73);
    mainBodyPath.quadraticBezierTo(w * 0.16, h * 0.82, w * 0.18, h * 0.85);
    mainBodyPath.lineTo(w * 0.5, h * 0.96);
    mainBodyPath.lineTo(w * 0.82, h * 0.85);
    mainBodyPath.quadraticBezierTo(w * 0.84, h * 0.82, w * 0.78, h * 0.73);
    mainBodyPath.quadraticBezierTo(w * 0.72, h * 0.65, w * 0.5, h * 0.68);
    mainBodyPath.close();
    canvas.drawPath(mainBodyPath, paint);

    final tasselPath = Path();
    tasselPath.moveTo(w * 0.5, h * 0.04);
    tasselPath.quadraticBezierTo(w * 0.55, h * 0.22, w * 0.58, h * 0.36);
    tasselPath.lineTo(w * 0.5, h * 0.46);
    tasselPath.lineTo(w * 0.42, h * 0.36);
    tasselPath.quadraticBezierTo(w * 0.45, h * 0.22, w * 0.5, h * 0.04);
    tasselPath.close();
    canvas.drawPath(tasselPath, tasselPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}