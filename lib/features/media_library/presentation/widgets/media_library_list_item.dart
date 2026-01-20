import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../../watch/domain/entities/movie_entity.dart';
import '../../../movie_details/presentation/pages/movie_detail_screen.dart';
import '../bloc/favorites_bloc.dart';

class MediaLibraryListItem extends StatelessWidget {
  final MovieEntity movie;

  const MediaLibraryListItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(movie: movie),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: movie.imageUrl.isNotEmpty
                  ? Image.network(
                      movie.imageUrl,
                      width: 100,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 100,
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(Icons.movie, color: Colors.grey),
                      ),
                    )
                  : Container(
                      width: 100,
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.movie, color: Colors.grey),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      movie.category.isEmpty
                          ? 'MOVIE'
                          : movie.category.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkPurple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.releaseDate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: AppColors.lightBlue),
              onPressed: () {
                context.read<FavoritesBloc>().add(RemoveFavorite(movie.id));
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
