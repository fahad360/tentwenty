import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_movie_showtimes_usecase.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetMovieShowtimesUseCase getMovieShowtimesUseCase;

  BookingBloc({required this.getMovieShowtimesUseCase})
    : super(BookingInitial()) {
    on<GetMovieShowtimes>(_onGetMovieShowtimes);
  }

  Future<void> _onGetMovieShowtimes(
    GetMovieShowtimes event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await getMovieShowtimesUseCase(
      GetMovieShowtimesParams(movieId: event.movieId, date: event.date),
    );
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (theaters) => emit(BookingLoaded(theaters)),
    );
  }
}
