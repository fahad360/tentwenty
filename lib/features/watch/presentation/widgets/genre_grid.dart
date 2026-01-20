import 'package:flutter/material.dart';
import '../../data/models/genre.dart';
import 'genre_card.dart';

class GenreGrid extends StatelessWidget {
  const GenreGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Genre> genres = [
      Genre(
        title: 'Comedies',
        imageUrl: 'https://picsum.photos/seed/comedy/400/300',
      ),
      Genre(
        title: 'Crime',
        imageUrl: 'https://picsum.photos/seed/crime/400/300',
      ),
      Genre(
        title: 'Family',
        imageUrl: 'https://picsum.photos/seed/family/400/300',
      ),
      Genre(
        title: 'Documentaries',
        imageUrl: 'https://picsum.photos/seed/documentary/400/300',
      ),
      Genre(
        title: 'Dramas',
        imageUrl: 'https://picsum.photos/seed/drama/400/300',
      ),
      Genre(
        title: 'Fantasy',
        imageUrl: 'https://picsum.photos/seed/fantasy/400/300',
      ),
      Genre(
        title: 'Holidays',
        imageUrl: 'https://picsum.photos/seed/holiday/400/300',
      ),
      Genre(
        title: 'Horror',
        imageUrl: 'https://picsum.photos/seed/horror/400/300',
      ),
      Genre(
        title: 'Sci-Fi',
        imageUrl: 'https://picsum.photos/seed/scifigenre/400/300',
      ),
      Genre(
        title: 'Thriller',
        imageUrl: 'https://picsum.photos/seed/thriller/400/300',
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.63,
      ),
      itemCount: genres.length,
      itemBuilder: (context, index) {
        return GenreCard(genre: genres[index]);
      },
    );
  }
}
