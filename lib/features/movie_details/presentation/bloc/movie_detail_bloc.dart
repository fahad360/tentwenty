import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_movie_details_usecase.dart';
import '../../domain/usecases/get_movie_trailers_usecase.dart';
import '../../../../features/media_library/domain/usecases/favorites_usecases.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetailsUseCase _getMovieDetailsUseCase;
  final GetMovieTrailersUseCase _getMovieTrailersUseCase;
  final SaveMovieUseCase _saveMovieUseCase;
  final RemoveMovieUseCase _removeMovieUseCase;
  final IsMovieFavoriteUseCase _isMovieFavoriteUseCase;

  MovieDetailBloc({
    required GetMovieDetailsUseCase getMovieDetailsUseCase,
    required GetMovieTrailersUseCase getMovieTrailersUseCase,
    required SaveMovieUseCase saveMovieUseCase,
    required RemoveMovieUseCase removeMovieUseCase,
    required IsMovieFavoriteUseCase isMovieFavoriteUseCase,
  }) : _getMovieDetailsUseCase = getMovieDetailsUseCase,
       _getMovieTrailersUseCase = getMovieTrailersUseCase,
       _saveMovieUseCase = saveMovieUseCase,
       _removeMovieUseCase = removeMovieUseCase,
       _isMovieFavoriteUseCase = isMovieFavoriteUseCase,
       super(MovieDetailInitial()) {
    on<GetMovieDetails>(_onGetMovieDetails);
    on<WatchTrailer>(_onWatchTrailer);
    on<ToggleFavorite>(_onToggleFavorite);
    on<CheckFavoriteStatus>(_onCheckFavoriteStatus);
  }

  Future<void> _onGetMovieDetails(
    GetMovieDetails event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoading());
    final result = await _getMovieDetailsUseCase(event.movieId);

    // Check favorite status immediately
    bool isFavorite = await _isMovieFavoriteUseCase(event.movieId);

    result.fold(
      (failure) => emit(MovieDetailError(_mapFailureToMessage(failure))),
      (movie) => emit(MovieDetailLoaded(movie, isFavorite: isFavorite)),
    );
  }

  Future<void> _onWatchTrailer(
    WatchTrailer event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await _getMovieTrailersUseCase(event.movieId);
    result.fold(
      (failure) => emit(MovieDetailError(_mapFailureToMessage(failure))),
      (videos) => emit(MovieTrailerLoaded(videos)),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<MovieDetailState> emit,
  ) async {
    MovieDetailLoaded? currentLoadedState;
    if (state is MovieDetailLoaded) {
      currentLoadedState = state as MovieDetailLoaded;
    }

    final isFav = await _isMovieFavoriteUseCase(event.movie.id);
    if (isFav) {
      await _removeMovieUseCase(event.movie.id);
      if (currentLoadedState != null) {
        emit(currentLoadedState.copyWith(isFavorite: false));
      } else {
        // Fallback if state was somehow not loaded (unlikely if viewing details)
        // We might need to reload details or just ignore?
        // For consistency, we can try to emit Loaded if we have the movie object
        emit(MovieDetailLoaded(event.movie, isFavorite: false));
      }
    } else {
      await _saveMovieUseCase(event.movie);
      if (currentLoadedState != null) {
        emit(currentLoadedState.copyWith(isFavorite: true));
      } else {
        emit(MovieDetailLoaded(event.movie, isFavorite: true));
      }
    }
  }

  Future<void> _onCheckFavoriteStatus(
    CheckFavoriteStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    final isFav = await _isMovieFavoriteUseCase(event.id);
    if (state is MovieDetailLoaded) {
      final currentState = state as MovieDetailLoaded;
      emit(currentState.copyWith(isFavorite: isFav));
    }
    // If not loaded, do nothing or fetch?
    // Usually triggered after loading or when returning.
  }

  String _mapFailureToMessage(dynamic failure) {
    return failure.toString();
  }
}
