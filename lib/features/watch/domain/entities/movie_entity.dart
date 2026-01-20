import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final int id; // Added ID for detailed fetching
  final String title;
  final String imageUrl;
  final String category;
  final String overview;
  final String releaseDate;
  final List<String> genres;
  final String trailerUrl;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    this.overview = '',
    this.releaseDate = '',
    this.genres = const [],
    this.trailerUrl = '',
  });

  @override
  List<Object?> get props => [
    id,
    title,
    imageUrl,
    category,
    overview,
    releaseDate,
    genres,
    trailerUrl,
  ];
}
