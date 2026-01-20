import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/theater_entity.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import 'mini_seat_map.dart';

class ShowtimeCard extends StatelessWidget {
  final int index;
  final ShowtimeEntity showtime;
  final bool isSelected;

  const ShowtimeCard({
    super.key,
    required this.index,
    required this.showtime,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<BookingBloc>().add(SelectShowtime(index));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: showtime.time,
                    style: const TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 10)),
                  TextSpan(
                    text: showtime.hall,
                    style: const TextStyle(
                      color: AppColors.greyLabel,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? AppColors.lightBlue : AppColors.inputFill,
                  width: isSelected ? 1 : 1,
                ),
                borderRadius: BorderRadius.circular(10),
                color: AppColors.white,
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: CustomPaint(painter: MiniSeatMapPainter()),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.greyLabel,
                ),
                children: [
                  const TextSpan(text: 'From '),
                  TextSpan(
                    text: '${showtime.price}\$',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const TextSpan(text: ' or '),
                  TextSpan(
                    text: '${showtime.bonusPoints} bonus',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
