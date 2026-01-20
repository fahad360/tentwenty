import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class GetMovieShowtimes extends BookingEvent {
  final int movieId;
  final String date;

  const GetMovieShowtimes(this.movieId, this.date);

  @override
  List<Object> get props => [movieId, date];
}

class SelectDate extends BookingEvent {
  final int index;
  const SelectDate(this.index);

  @override
  List<Object> get props => [index];
}

class SelectShowtime extends BookingEvent {
  final int index;
  const SelectShowtime(this.index);

  @override
  List<Object> get props => [index];
}

class ToggleSeat extends BookingEvent {
  final int row;
  final int col;
  const ToggleSeat(this.row, this.col);

  @override
  List<Object> get props => [row, col];
}

class LoadSeats extends BookingEvent {
  // Mock event to trigger seat generation
  const LoadSeats();
}
