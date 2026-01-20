import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_upcoming_movies_usecase.dart';
import '../../domain/usecases/search_movies_usecase.dart';
import 'watch_event.dart';
import 'watch_state.dart';

class WatchBloc extends Bloc<WatchEvent, WatchState> {
  final GetUpcomingMoviesUseCase getUpcomingMoviesUseCase;
  final SearchMoviesUseCase searchMoviesUseCase;

  WatchBloc({
    required this.getUpcomingMoviesUseCase,
    required this.searchMoviesUseCase,
  }) : super(WatchInitial()) {
    on<GetUpcomingMovies>(_onGetUpcomingMovies);
    on<SearchMovies>(_onSearchMovies);
  }

  Future<void> _onGetUpcomingMovies(
    GetUpcomingMovies event,
    Emitter<WatchState> emit,
  ) async {
    emit(WatchLoading());
    final result = await getUpcomingMoviesUseCase(NoParams());
    result.fold(
      (failure) => emit(WatchError(failure.message)),
      (movies) => emit(WatchLoaded(movies)),
    );
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<WatchState> emit,
  ) async {
    emit(WatchLoading());
    final result = await searchMoviesUseCase(event.query);
    result.fold(
      (failure) => emit(WatchError(failure.message)),
      (movies) => emit(WatchLoaded(movies)),
    );
  }
}
