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
