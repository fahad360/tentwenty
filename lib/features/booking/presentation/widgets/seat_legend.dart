import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/colors.dart';

class SeatLegend extends StatelessWidget {
  const SeatLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLegendItem(AppColors.seatSelected, 'Selected'),
            _buildLegendItem(AppColors.seatTaken, 'Not available'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLegendItem(AppColors.seatVip, 'VIP (150\$)'),
            _buildLegendItem(AppColors.seatRegular, 'Regular (50 \$)'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/svgs/seat.svg',
          width: 20,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.greyLabel,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
