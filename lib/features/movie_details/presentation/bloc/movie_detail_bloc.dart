import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/error_model.dart';
import '../../domain/usecases/get_movie_details_usecase.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetailsUseCase _getMovieDetailsUseCase;

  MovieDetailBloc({required GetMovieDetailsUseCase getMovieDetailsUseCase})
    : _getMovieDetailsUseCase = getMovieDetailsUseCase,
      super(MovieDetailInitial()) {
    on<GetMovieDetails>(_onGetMovieDetails);
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
