import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class CinemaScreenWidget extends StatelessWidget {
  const CinemaScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(size: const Size(400, 50), painter: _ScreenPainter()),
        const SizedBox(height: 20),
        const Text(
          "SCREEN",
          style: TextStyle(fontSize: 10, color: AppColors.greyLabel),
        ),
      ],
    );
  }
}

class _ScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height);

    canvas.drawPath(path, paint);

    // Shadow effect
    final shadowPaint = Paint()
      ..color = AppColors.lightBlue.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final shadowPath = Path();
    shadowPath.moveTo(0, size.height);
    shadowPath.quadraticBezierTo(size.width / 2, 0, size.width, size.height);
    shadowPath.lineTo(size.width, size.height + 20);
    shadowPath.lineTo(0, size.height + 20);
    shadowPath.close();

    canvas.drawPath(shadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
