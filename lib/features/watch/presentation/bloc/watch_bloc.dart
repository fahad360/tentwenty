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
  }) : super(const WatchState()) {
    on<GetUpcomingMovies>(_onGetUpcomingMovies);
    on<SearchMovies>(_onSearchMovies);
    on<ToggleSearch>(_onToggleSearch);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SubmitSearch>(_onSubmitSearch);
  }

  Future<void> _onGetUpcomingMovies(
    GetUpcomingMovies event,
    Emitter<WatchState> emit,
  ) async {
    emit(state.copyWith(status: WatchStatus.loading));
    final result = await getUpcomingMoviesUseCase(NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: WatchStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (movies) =>
          emit(state.copyWith(status: WatchStatus.success, movies: movies)),
    );
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<WatchState> emit,
  ) async {
    emit(state.copyWith(status: WatchStatus.loading));
    final result = await searchMoviesUseCase(event.query);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: WatchStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (movies) =>
          emit(state.copyWith(status: WatchStatus.success, movies: movies)),
    );
  }

  void _onToggleSearch(ToggleSearch event, Emitter<WatchState> emit) {
    if (state.isSearchActive) {
      emit(
        state.copyWith(
          isSearchActive: false,
          isSearchSubmitted: false,
          searchQuery: '',
        ),
      );
      add(GetUpcomingMovies());
    } else {
      emit(state.copyWith(isSearchActive: true));
    }
  }

  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<WatchState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query, isSearchSubmitted: false));
    if (event.query.isEmpty) {
      add(GetUpcomingMovies());
    } else {
      add(SearchMovies(event.query));
    }
  }

  void _onSubmitSearch(SubmitSearch event, Emitter<WatchState> emit) {
    emit(state.copyWith(isSearchSubmitted: true));
    if (state.searchQuery.isNotEmpty) {
      add(SearchMovies(state.searchQuery));
    }
  }
}
