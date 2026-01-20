import 'package:equatable/equatable.dart';

abstract class WatchEvent extends Equatable {
  const WatchEvent();

  @override
  List<Object> get props => [];
}

class GetUpcomingMovies extends WatchEvent {}

class SearchMovies extends WatchEvent {
  final String query;
  const SearchMovies(this.query);

  @override
  List<Object> get props => [query];
}
