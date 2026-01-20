import 'package:equatable/equatable.dart';
import '../../domain/entities/theater_entity.dart';
import '../../data/models/cinema_data.dart';

enum BookingStatus { initial, loading, success, error }

class BookingState extends Equatable {
  final BookingStatus status;
  final List<TheaterEntity> theaters;
  final int selectedDateIndex;
  final int? selectedShowtimeIndex;
  final List<List<Seat>> seats; // Add seats grid
  final double totalPrice;
  final String errorMessage;

  const BookingState({
    this.status = BookingStatus.initial,
    this.theaters = const [],
    this.selectedDateIndex = 0,
    this.selectedShowtimeIndex,
    this.seats = const [],
    this.totalPrice = 0,
    this.errorMessage = '',
  });

  BookingState copyWith({
    BookingStatus? status,
    List<TheaterEntity>? theaters,
    int? selectedDateIndex,
    int? selectedShowtimeIndex,
    bool clearShowtimeSelection = false,
    List<List<Seat>>? seats,
    double? totalPrice,
    String? errorMessage,
  }) {
    return BookingState(
      status: status ?? this.status,
      theaters: theaters ?? this.theaters,
      selectedDateIndex: selectedDateIndex ?? this.selectedDateIndex,
      selectedShowtimeIndex: clearShowtimeSelection
          ? null
          : (selectedShowtimeIndex ?? this.selectedShowtimeIndex),
      seats: seats ?? this.seats,
      totalPrice: totalPrice ?? this.totalPrice,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    theaters,
    selectedDateIndex,
    selectedShowtimeIndex,
    seats,
    totalPrice,
    errorMessage,
  ];
}
