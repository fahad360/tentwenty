import 'package:equatable/equatable.dart';

class TheaterEntity extends Equatable {
  final String name;
  final String location;
  final List<ShowtimeEntity> showtimes;

  const TheaterEntity({
    required this.name,
    required this.location,
    required this.showtimes,
  });

  @override
  List<Object?> get props => [name, location, showtimes];
}

class ShowtimeEntity extends Equatable {
  final String time;
  final String hall;
  final int price;
  final int bonusPoints;

  const ShowtimeEntity({
    required this.time,
    required this.hall,
    required this.price,
    this.bonusPoints = 0,
  });

  @override
  List<Object?> get props => [time, hall, price, bonusPoints];
}
