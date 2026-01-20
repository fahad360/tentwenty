import 'package:equatable/equatable.dart';
import '../../domain/entities/movie_entity.dart';

abstract class WatchState extends Equatable {
  const WatchState();

  @override
  List<Object> get props => [];
}

class WatchInitial extends WatchState {}

class WatchLoading extends WatchState {}

class WatchLoaded extends WatchState {
  final List<MovieEntity> movies;
  const WatchLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class WatchError extends WatchState {
  final String message;
  const WatchError(this.message);

  @override
  List<Object> get props => [message];
}
