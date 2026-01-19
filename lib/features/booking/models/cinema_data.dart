enum SeatStatus { available, taken, selected }

enum SeatType { regular, vip }

class Seat {
  final int row;
  final int number;
  final SeatType type;
  SeatStatus status;
  final double price;

  Seat({
    required this.row,
    required this.number,
    this.type = SeatType.regular,
    this.status = SeatStatus.available,
    required this.price,
  });
}

class CinemaHall {
  final String name;
  final List<Seat> seats;

  CinemaHall({required this.name, required this.seats});
}

class Showtime {
  final String time;
  final String hallName;
  final int price;
  final int bonus;

  Showtime({
    required this.time,
    required this.hallName,
    required this.price,
    required this.bonus,
  });
}
