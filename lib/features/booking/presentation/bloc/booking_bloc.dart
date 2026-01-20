import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_movie_showtimes_usecase.dart';
import 'booking_event.dart';
import 'booking_state.dart';
import '../../data/models/cinema_data.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetMovieShowtimesUseCase getMovieShowtimesUseCase;

  BookingBloc({required this.getMovieShowtimesUseCase})
    : super(const BookingState()) {
    on<GetMovieShowtimes>(_onGetMovieShowtimes);
    on<SelectDate>(_onSelectDate);
    on<SelectShowtime>(_onSelectShowtime);
    on<LoadSeats>(_onLoadSeats);
    on<ToggleSeat>(_onToggleSeat);
  }

  Future<void> _onGetMovieShowtimes(
    GetMovieShowtimes event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(status: BookingStatus.loading));
    final result = await getMovieShowtimesUseCase(
      GetMovieShowtimesParams(movieId: event.movieId, date: event.date),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (theaters) => emit(
        state.copyWith(status: BookingStatus.success, theaters: theaters),
      ),
    );
  }

  void _onSelectDate(SelectDate event, Emitter<BookingState> emit) {
    emit(
      state.copyWith(
        selectedDateIndex: event.index,
        clearShowtimeSelection: true,
      ),
    );
    // Ideally we might refetch showtimes here if they depend on date,
    // but the current implementation expects one fetch or assumes we handle it.
    // The previous UI code reset selection, but showtimes were static or fetched once.
    // Given the GetMovieShowtimes event takes a date, we probably SHOULD fetch new showtimes.
    // However, the `_dates` list in UI is just strings.
    // If we want to be correct, we should emit loading and fetch new showtimes for the new date.
    // But for this refactor, I will match the UI behavior which just changed index.
    // Wait, the UI called `GetMovieShowtimes(..., "March 5, 2021")` ONCE in initState/create.
    // Changing the date pill just changed the highlight.
    // It didn't trigger a new API call in the code I saw.
    // So I will just update the index.
  }

  void _onSelectShowtime(SelectShowtime event, Emitter<BookingState> emit) {
    emit(state.copyWith(selectedShowtimeIndex: event.index));
  }

  void _onLoadSeats(LoadSeats event, Emitter<BookingState> emit) {
    if (state.seats.isNotEmpty) return; // Already loaded

    final int _rows = 10;
    final int _cols = 24;

    final seats = List.generate(_rows, (rowIndex) {
      return List.generate(_cols, (colIndex) {
        SeatStatus status = SeatStatus.available;
        SeatType type = SeatType.regular;

        // Randomly assign some seats as taken or VIP (Logic from SeatSelectionScreen)
        if ((rowIndex + colIndex) % 11 == 0) status = SeatStatus.taken;
        if (rowIndex > 7) type = SeatType.vip;

        return Seat(
          row: rowIndex + 1,
          number: colIndex + 1,
          type: type,
          status: status,
          price: type == SeatType.vip ? 150 : 50,
        );
      });
    });

    emit(state.copyWith(seats: seats));
  }

  void _onToggleSeat(ToggleSeat event, Emitter<BookingState> emit) {
    // We need to create a new list of list to ensure immutability and rebuild
    final newSeats = state.seats
        .map(
          (row) => row.map((seat) {
            if (seat.row == event.row && seat.number == event.col) {
              // Return new seat with updated status
              SeatStatus newStatus = seat.status;
              if (seat.status == SeatStatus.available) {
                newStatus = SeatStatus.selected;
              } else if (seat.status == SeatStatus.selected) {
                newStatus = SeatStatus.available;
              }
              // Return copy of seat (Seat class is mutable in current code, but we should probably treat it effectively immutable or careful)
              // Seat class fields are final except status.
              // Let's create a NEW Seat object to be safe and cleaner for Bloc
              return Seat(
                row: seat.row,
                number: seat.number,
                type: seat.type,
                price: seat.price,
                status: newStatus,
              );
            }
            return seat;
          }).toList(),
        )
        .toList();

    double totalPrice = 0;
    for (var row in newSeats) {
      for (var seat in row) {
        if (seat.status == SeatStatus.selected) {
          totalPrice += seat.price;
        }
      }
    }

    emit(state.copyWith(seats: newSeats, totalPrice: totalPrice));
  }
}
