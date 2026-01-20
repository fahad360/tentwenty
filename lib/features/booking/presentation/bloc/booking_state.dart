import 'package:equatable/equatable.dart';
import '../../domain/entities/theater_entity.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<TheaterEntity> theaters;
  const BookingLoaded(this.theaters);

  @override
  List<Object> get props => [theaters];
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);

  @override
  List<Object> get props => [message];
}
