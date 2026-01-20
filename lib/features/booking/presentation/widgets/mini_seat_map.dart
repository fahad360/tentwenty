import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class MiniSeatMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Screen Curve
    final path = Path();
    path.moveTo(size.width * 0.2, 0); // Moved up slightly
    path.quadraticBezierTo(size.width * 0.5, -8, size.width * 0.8, 0);
    canvas.drawPath(path, paint);

    // Seats
    final seatPaint = Paint()..style = PaintingStyle.fill;

    // Grid configuration
    const rows = 10;
    const cols = 14;

    // Calculate seat size to fit ensuring no overflow
    // Available height ~ 100px (145 height - 40 padding - screen space)
    // Available width ~ 200px
    final seatW = (size.width / cols) * 0.65; // Use 65% of cell width
    final seatH = seatW * 0.8; // Maintain aspect ratio
    final gapX = (size.width / cols) * 0.35;
    final gapY = seatH * 0.6;

    final startX = (size.width - (cols * (seatW + gapX))) / 2 + gapX / 2;
    const startY = 12.0;

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        // Colors logic
        Color color;
        if (i > 6) {
          color = (j % 5 == 0 || j % 3 == 0)
              ? AppColors.pink
              : AppColors.seatVip;
        } else {
          color = AppColors.lightBlue;
        }
        if ((i + j) % 7 == 0 || (i * j) % 5 == 0) {
          color = color.withValues(alpha: 0.2); // Random-ish using withValues
        }

        seatPaint.color = color;

        double x = startX + j * (seatW + gapX);
        double y = startY + i * (seatH + gapY);

        // Curve offset
        y += (j - cols / 2).abs() * 0.5 + (i * i * 0.05);

        // Draw Seat Shape (Mimic SVG: Big Rect + Small Bottom Rect)
        // Back
        final backRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, seatW, seatH * 0.7),
          Radius.circular(seatW * 0.2),
        );
        canvas.drawRRect(backRect, seatPaint);

        // Bottom/Legs
        final floorRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x + seatW * 0.15,
            y + seatH * 0.85,
            seatW * 0.7,
            seatH * 0.15,
          ),
          Radius.circular(seatW * 0.1),
        );
        canvas.drawRRect(floorRect, seatPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
