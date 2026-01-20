import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/favorites_usecases.dart';
import 'dart:async';
import '../../../../features/watch/domain/repositories/movie_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

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
      emit(FavoritesError(failure.toString()));
    }, (movies) => emit(FavoritesLoaded(movies)));
  }

  Future<void> _onRemoveFavorite(
    RemoveFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    await removeMovieUseCase(event.movieId);
  }
}
