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
