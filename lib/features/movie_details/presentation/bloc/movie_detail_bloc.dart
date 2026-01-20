import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/error_model.dart';
import '../../domain/usecases/get_movie_details_usecase.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

import '../../domain/usecases/get_movie_trailers_usecase.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetailsUseCase _getMovieDetailsUseCase;
  final GetMovieTrailersUseCase _getMovieTrailersUseCase;

  MovieDetailBloc({
    required GetMovieDetailsUseCase getMovieDetailsUseCase,
    required GetMovieTrailersUseCase getMovieTrailersUseCase,
  }) : _getMovieDetailsUseCase = getMovieDetailsUseCase,
       _getMovieTrailersUseCase = getMovieTrailersUseCase,
       super(MovieDetailInitial()) {
    on<GetMovieDetails>(_onGetMovieDetails);
    on<WatchTrailer>(_onWatchTrailer);
  }

  Future<void> _onGetMovieDetails(
    GetMovieDetails event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoading());
    final result = await _getMovieDetailsUseCase(event.movieId);
    result.fold(
      (failure) => emit(MovieDetailError(_mapFailureToMessage(failure))),
      (movie) => emit(MovieDetailLoaded(movie)),
    );
  }

  Future<void> _onWatchTrailer(
    WatchTrailer event,
    Emitter<MovieDetailState> emit,
  ) async {
    // Keep current state if possible or emit specific loading?
    // For now, let's just fetch.
    final result = await _getMovieTrailersUseCase(event.movieId);
    result.fold(
      (failure) => emit(MovieDetailError(_mapFailureToMessage(failure))),
      (videos) => emit(MovieTrailerLoaded(videos)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server Failure';
    } else if (failure is NetworkFailure) {
      return 'Network Failure';
    } else {
      return 'Unexpected Error';
    }
  }
}
