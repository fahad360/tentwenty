import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class GenreChip extends StatelessWidget {
  final String label;

  const GenreChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    switch (label) {
      case 'Action':
        chipColor = AppColors.teal;
        break;
      case 'Thriller':
        chipColor = AppColors.pink;
        break;
      case 'Science':
        chipColor = AppColors.seatVip; // purple
        break;
      case 'Fiction':
        chipColor = AppColors.seatSelected; // gold
        break;
      default:
        chipColor = AppColors.grey; // Default color for unknown genres
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
