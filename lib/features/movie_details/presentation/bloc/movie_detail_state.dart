import 'package:equatable/equatable.dart';
import '../../../watch/domain/entities/movie_entity.dart';
import '../../../watch/domain/entities/video_entity.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieEntity movie;
  final bool isFavorite;

  const MovieDetailLoaded(this.movie, {this.isFavorite = false});

  @override
  List<Object> get props => [movie, isFavorite];

  MovieDetailLoaded copyWith({MovieEntity? movie, bool? isFavorite}) {
    return MovieDetailLoaded(
      movie ?? this.movie,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class MovieDetailError extends MovieDetailState {
  final String message;
  const MovieDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieTrailerLoaded extends MovieDetailState {
  final List<VideoEntity> videos;
  const MovieTrailerLoaded(this.videos);

  @override
  List<Object> get props => [videos];
}
