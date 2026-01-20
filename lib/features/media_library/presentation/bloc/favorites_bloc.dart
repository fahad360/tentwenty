import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/watch/domain/entities/movie_entity.dart';
import '../../domain/usecases/favorites_usecases.dart';
import 'dart:async';
import '../../../../features/watch/domain/repositories/movie_repository.dart';

// Events
abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class RemoveFavorite extends FavoritesEvent {
  final int movieId;
  const RemoveFavorite(this.movieId);
  @override
  List<Object> get props => [movieId];
}

// States
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

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritesUseCase getFavoritesUseCase;
  final RemoveMovieUseCase removeMovieUseCase;
  final MovieRepository _repository;
  StreamSubscription? _subscription;

  FavoritesBloc({
    required this.getFavoritesUseCase,
    required this.removeMovieUseCase,
    required MovieRepository repository,
  }) : _repository = repository,
       super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<RemoveFavorite>(_onRemoveFavorite);

    _subscription = _repository.onFavoritesChanged.listen((_) {
      add(LoadFavorites());
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());
    final result = await getFavoritesUseCase();
    result.fold((failure) {
      // Assuming Failure has a message property or we convert it
      // Check Failure definition. Abstract class Failure extends Equatable.
      // It should have props.
      // Let's assume error_model has ServerFailure(message) etc.
      // If message is not on base class, we might need to cast or use toString.
      // For MVP, lets use toString or check if concrete classes have message.
      // ServerFailure usually has message.
      // Let's safe cast or use toString for now.
      emit(FavoritesError(failure.toString()));
    }, (movies) => emit(FavoritesLoaded(movies)));
  }

  Future<void> _onRemoveFavorite(
    RemoveFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    // We don't necessarily need to emit loading here as the stream will trigger reload.
    // But we might want to optimistically update or just wait for stream.
    // Since we have the stream, let's just perform the action.
    await removeMovieUseCase(event.movieId);
  }
}
