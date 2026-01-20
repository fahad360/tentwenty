import 'package:equatable/equatable.dart';
import '../../../../features/watch/domain/entities/movie_entity.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<MovieEntity> movies;

  const FavoritesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object> get props => [message];
}
