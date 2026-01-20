import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../data/models/cinema_data.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';

class SeatWidget extends StatelessWidget {
  final Seat seat;

  const SeatWidget({super.key, required this.seat});

  @override
  Widget build(BuildContext context) {
    Color color;

    if (seat.status == SeatStatus.selected) {
      color = AppColors.seatSelected;
    } else if (seat.status == SeatStatus.taken) {
      color = AppColors.seatTaken;
    } else if (seat.type == SeatType.vip) {
      color = AppColors.seatVip;
    } else {
      color = AppColors.seatRegular;
    }

    return GestureDetector(
      onTap: seat.status == SeatStatus.taken
          ? null
          : () {
              context.read<BookingBloc>().add(
                ToggleSeat(seat.row, seat.number),
              );
            },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 20,
        height: 20,
        child: SvgPicture.asset(
          'assets/svgs/seat.svg',
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
    );
  }
}
