import 'package:flutter/material.dart';
import '../../domain/entities/movie_entity.dart';

class SearchResultTile extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback? onTap;

  const SearchResultTile({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            // Movie Image
            Container(
              width: 130,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300], // Placeholder background
              ),
              clipBehavior: Clip.hardEdge,
              child: movie.imageUrl.isNotEmpty
                  ? Image.network(
                      movie.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },
                    )
                  : const Center(child: Icon(Icons.movie, color: Colors.grey)),
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
                      color: Color(0xFFB1B1B1),
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
      ),
    );
  }
}
