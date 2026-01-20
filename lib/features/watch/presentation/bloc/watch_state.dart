import 'package:equatable/equatable.dart';
import '../../domain/entities/movie_entity.dart';

enum WatchStatus { initial, loading, success, error }

class WatchState extends Equatable {
  final WatchStatus status;
  final List<MovieEntity> movies;
  final bool isSearchActive;
  final bool isSearchSubmitted;
  final String searchQuery;
  final String errorMessage;

  const WatchState({
    this.status = WatchStatus.initial,
    this.movies = const [],
    this.isSearchActive = false,
    this.isSearchSubmitted = false,
    this.searchQuery = '',
    this.errorMessage = '',
  });

  WatchState copyWith({
    WatchStatus? status,
    List<MovieEntity>? movies,
    bool? isSearchActive,
    bool? isSearchSubmitted,
    String? searchQuery,
    String? errorMessage,
  }) {
    return WatchState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      isSearchActive: isSearchActive ?? this.isSearchActive,
      isSearchSubmitted: isSearchSubmitted ?? this.isSearchSubmitted,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
    status,
    movies,
    isSearchActive,
    isSearchSubmitted,
    searchQuery,
    errorMessage,
  ];
}
