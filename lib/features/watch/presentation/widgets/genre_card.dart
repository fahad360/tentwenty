import 'package:flutter/material.dart';
import '../../data/models/genre.dart';
import '../../../../core/theme/colors.dart';

class GenreCard extends StatelessWidget {
  final Genre genre;

  const GenreCard({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(genre.imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.black.withValues(alpha: 0.2),
            BlendMode.darken,
          ),
        ),
      ),
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          genre.title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
