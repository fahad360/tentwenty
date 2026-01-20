import '../../../../features/watch/domain/entities/movie_entity.dart';
import 'package:equatable/equatable.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class GetMovieDetails extends MovieDetailEvent {
  final int movieId;
  const GetMovieDetails(this.movieId);

  @override
  List<Object> get props => [movieId];
}

class WatchTrailer extends MovieDetailEvent {
  final int movieId;
  const WatchTrailer(this.movieId);

  @override
  List<Object> get props => [movieId];
}

class ToggleFavorite extends MovieDetailEvent {
  final MovieEntity movie;
  const ToggleFavorite(this.movie);

  @override
  List<Object> get props => [movie];
}

class CheckFavoriteStatus extends MovieDetailEvent {
  final int id;
  const CheckFavoriteStatus(this.id);

  @override
  List<Object> get props => [id];
}
