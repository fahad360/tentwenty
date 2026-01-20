// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  imageUrl: json['imageUrl'] as String,
  category: json['category'] as String,
  overview: json['overview'] as String? ?? '',
  releaseDate: json['releaseDate'] as String? ?? '',
  genres:
      (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  trailerUrl: json['trailerUrl'] as String? ?? '',
);

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'category': instance.category,
      'overview': instance.overview,
      'releaseDate': instance.releaseDate,
      'genres': instance.genres,
      'trailerUrl': instance.trailerUrl,
    };
