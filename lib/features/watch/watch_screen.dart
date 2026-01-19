import 'package:flutter/material.dart';

import 'models/movie.dart';
import 'widgets/movie_card.dart';

class WatchScreen extends StatefulWidget {
  const WatchScreen({super.key});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  // Dummy data
  final List<Movie> _movies = [
    Movie(
      title: 'Free Guy',
      imageUrl:
          'https://image.tmdb.org/t/p/original/8Y43POKjjKDGI9MH89NW0NA85Ek.jpg',
      category: 'Fantasy',
    ),
    Movie(
      title: 'The King\'s Man',
      imageUrl:
          'https://image.tmdb.org/t/p/original/nj5HmHRZsrYQEYYXyAusFv35erP.jpg',
      category: 'Action',
    ),
    Movie(
      title: 'Jojo Rabbit',
      imageUrl:
          'https://image.tmdb.org/t/p/original/7GsM4mtM0worCtIVeiQt28HieeN.jpg',
      category: 'Drama',
    ),
    Movie(
      title: 'Sci-Fi Hits',
      imageUrl: 'https://picsum.photos/id/16/800/400',
      category: 'Sci-Fi',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          return MovieCard(movie: _movies[index]);
        },
      ),
    );
  }
}
