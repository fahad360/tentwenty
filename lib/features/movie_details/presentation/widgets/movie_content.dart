import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../features/watch/domain/entities/movie_entity.dart';
import 'genre_chip.dart';

class MovieContent extends StatelessWidget {
  final MovieEntity movie;

  const MovieContent({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Genres',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: movie.genres
                .map((genre) => GenreChip(label: genre))
                .toList(),
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.lightGrey),
          const SizedBox(height: 20),
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            movie.overview,
            style: const TextStyle(
              fontSize: 12,
              height: 1.5,
              color: AppColors.greyLabel,
            ),
          ),
        ],
      ),
    );
  }
}
