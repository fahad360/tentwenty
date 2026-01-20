import 'package:flutter/material.dart';
import '../../domain/entities/movie_entity.dart';

class SearchResultTile extends StatelessWidget {
  final MovieEntity movie;

  const SearchResultTile({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          // Movie Image
          Container(
            width: 130,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(movie.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Title and Category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF202C43),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.category,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFDBDBDF),
                  ),
                ),
              ],
            ),
          ),
          // Menu Icon
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Color(0xFF61C3F2)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
