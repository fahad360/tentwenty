import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/movie_entity.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel extends MovieEntity {
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'genre_ids')
  final List<int>? genreIds;
  @JsonKey(name: 'release_date')
  final String? releaseDateRaw;

  // Static map for Genre IDs (Standard TMDB IDs)
  static const Map<int, String> _genreMap = {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Sci-Fi',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western',
  };

  MovieModel({
    required super.id,
    required super.title,
    this.posterPath,
    this.backdropPath,
    this.genreIds,
    String? overview,
    this.releaseDateRaw,
  }) : super(
         imageUrl: posterPath != null
             ? 'https://image.tmdb.org/t/p/w500$posterPath'
             : '', 
         category: genreIds != null && genreIds.isNotEmpty
             ? _genreMap[genreIds.first] ?? 'Unknown'
             : 'Unknown',
         overview: overview ?? '',
         releaseDate: releaseDateRaw ?? '',
         genres:
             genreIds
                 ?.map((id) => _genreMap[id] ?? '')
                 .where((name) => name.isNotEmpty)
                 .toList() ??
             const [],
         trailerUrl: '', // Not provided by this endpoint directly
       );

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);
}

@JsonSerializable()
class MovieResponse {
  final List<MovieModel> results;

  MovieResponse({required this.results});

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);
}
