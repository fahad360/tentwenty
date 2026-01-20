import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../watch/domain/entities/movie_entity.dart';
// Note: We use the Entity definition for Showtime to map from the Bloc
import '../../domain/entities/theater_entity.dart';
import '../../data/models/cinema_data.dart' as legacy;
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import 'seat_selection_screen.dart';
import '../../../../core/widgets/skeleton_widgets.dart';

// Helper model to match the UI's expectation if differs from Entity, or we use Entity directly.
// The Entity has: time, hall, price, bonusPoints.
// The UI expects: time, hallName, price, bonus.
// We can use the Entity directly and map property access.

class TicketBookingScreen extends StatefulWidget {
  final MovieEntity movie;

  const TicketBookingScreen({super.key, required this.movie});

  @override
  State<TicketBookingScreen> createState() => _TicketBookingScreenState();
}

class _TicketBookingScreenState extends State<TicketBookingScreen> {
  // Dates are still static for now as per previous implementation
  final List<String> _dates = [
    '5 Mar',
    '6 Mar',
    '7 Mar',
    '8 Mar',
    '9 Mar',
    '10 Mar',
    '11 Mar',
    '12 Mar',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<BookingBloc>()
            ..add(GetMovieShowtimes(widget.movie.id, "March 5, 2021")),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F6),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Column(
            children: [
              Text(
                widget.movie.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'In Theaters ${widget.movie.releaseDate}',
                style: const TextStyle(
                  color: Color(0xFF61C3F2),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state.status == BookingStatus.loading) {
              return const SkeletonTicketBooking();
            } else if (state.status == BookingStatus.error) {
              return Center(child: Text(state.errorMessage));
            } else if (state.status == BookingStatus.success) {
              // Flatten showtimes from all theaters
              final allShowtimes = state.theaters
                  .expand((t) => t.showtimes)
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20, top: 30, bottom: 15),
                    child: Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF202C43),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: _dates.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        bool isSelected = state.selectedDateIndex == index;
                        return GestureDetector(
                          onTap: () {
                            context.read<BookingBloc>().add(SelectDate(index));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF61C3F2)
                                  : const Color(0x1A000000),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _dates[index],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: allShowtimes.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        return _buildShowtimeCard(
                          context,
                          index,
                          allShowtimes[index],
                          state,
                        );
                      },
                    ),
                  ),
                  const Spacer(), // Push button to bottom
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: state.selectedShowtimeIndex != null
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      final selectedEntity =
                                          allShowtimes[state
                                              .selectedShowtimeIndex!];
                                      return BlocProvider.value(
                                        value: context.read<BookingBloc>(),
                                        child: SeatSelectionScreen(
                                          movie: widget.movie,
                                          date: _dates[state.selectedDateIndex],
                                          showtime: legacy.Showtime(
                                            time: selectedEntity.time,
                                            hallName: selectedEntity.hall,
                                            price: selectedEntity.price,
                                            bonus: selectedEntity.bonusPoints,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF61C3F2),
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Select Seats',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildShowtimeCard(
    BuildContext context,
    int index,
    ShowtimeEntity showtime,
    BookingState state,
  ) {
    bool isSelected = state.selectedShowtimeIndex == index;

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
                      color: Color(0xFF202C43),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 10)),
                  TextSpan(
                    text: showtime.hall,
                    style: const TextStyle(
                      color: Color(0xFF8F8F8F),
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
                  color: isSelected
                      ? const Color(0xFF61C3F2)
                      : const Color(0xFFEFEFEF),
                  width: isSelected ? 1 : 1,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: CustomPaint(painter: MiniSeatMapPainter()),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 12, color: Color(0xFF8F8F8F)),
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

class MiniSeatMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF61C3F2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Screen Curve
    final path = Path();
    path.moveTo(size.width * 0.2, 0); // Moved up slightly
    path.quadraticBezierTo(size.width * 0.5, -8, size.width * 0.8, 0);
    canvas.drawPath(path, paint);

    // Seats
    final seatPaint = Paint()..style = PaintingStyle.fill;

    // Grid configuration
    const rows = 10;
    const cols = 14;

    // Calculate seat size to fit ensuring no overflow
    // Available height ~ 100px (145 height - 40 padding - screen space)
    // Available width ~ 200px
    final seatW = (size.width / cols) * 0.65; // Use 65% of cell width
    final seatH = seatW * 0.8; // Maintain aspect ratio
    final gapX = (size.width / cols) * 0.35;
    final gapY = seatH * 0.6;

    final startX = (size.width - (cols * (seatW + gapX))) / 2 + gapX / 2;
    const startY = 12.0;

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        // Colors logic
        Color color;
        if (i > 6) {
          color = (j % 5 == 0 || j % 3 == 0)
              ? const Color(0xFFE26CA5)
              : const Color(0xFF564CA3);
        } else {
          color = const Color(0xFF61C3F2);
        }
        if ((i + j) % 7 == 0 || (i * j) % 5 == 0) {
          color = color.withValues(alpha: 0.2); // Random-ish using withValues
        }

        seatPaint.color = color;

        double x = startX + j * (seatW + gapX);
        double y = startY + i * (seatH + gapY);

        // Curve offset
        y += (j - cols / 2).abs() * 0.5 + (i * i * 0.05);

        // Draw Seat Shape (Mimic SVG: Big Rect + Small Bottom Rect)
        // Back
        final backRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, seatW, seatH * 0.7),
          Radius.circular(seatW * 0.2),
        );
        canvas.drawRRect(backRect, seatPaint);

        // Bottom/Legs
        final floorRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x + seatW * 0.15,
            y + seatH * 0.85,
            seatW * 0.7,
            seatH * 0.15,
          ),
          Radius.circular(seatW * 0.1),
        );
        canvas.drawRRect(floorRect, seatPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
