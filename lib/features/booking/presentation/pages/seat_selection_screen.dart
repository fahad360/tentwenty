import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../watch/domain/entities/movie_entity.dart';
import '../../data/models/cinema_data.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_state.dart';
import '../bloc/booking_event.dart';
import '../../../../core/theme/colors.dart';
import '../widgets/cinema_screen_widget.dart';
import '../widgets/seat_widget.dart';
import '../widgets/zoom_controls.dart';
import '../widgets/seat_legend.dart';
import '../widgets/booking_price_footer.dart';

class SeatSelectionScreen extends StatefulWidget {
  final MovieEntity movie;
  final String date;
  final Showtime showtime;

  const SeatSelectionScreen({
    super.key,
    required this.movie,
    required this.date,
    required this.showtime,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    // Load seats when entering the screen
    context.read<BookingBloc>().add(const LoadSeats());
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            Text(
              widget.movie.title,
              style: const TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${widget.date} | ${widget.showtime.time} ${widget.showtime.hallName}',
              style: const TextStyle(
                color: AppColors.lightBlue,
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
          if (state.seats.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          int selectedCount = 0;
          for (var row in state.seats) {
            for (var seat in row) {
              if (seat.status == SeatStatus.selected) selectedCount++;
            }
          }

          return SafeArea(
            child: Column(
              children: [
                // Seat Map
                Expanded(
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    panEnabled: true,
                    scaleEnabled: true,
                    minScale: 0.5,
                    maxScale: 3.0,
                    constrained: false,
                    boundaryMargin: const EdgeInsets.all(100),
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          const CinemaScreenWidget(),
                          const SizedBox(height: 30),

                          // Seats
                          ...List.generate(state.seats.length, (i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Row number
                                  SizedBox(
                                    width: 20,
                                    child: Text(
                                      '${i + 1}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.darkBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  ...List.generate(state.seats[i].length, (j) {
                                    // Add aisle gap
                                    if (j == 6 || j == 18) {
                                      return const SizedBox(width: 30);
                                    }
                                    return SeatWidget(seat: state.seats[i][j]);
                                  }),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),

                // Controls to Zoom
                ZoomControls(controller: _transformationController),

                // Legend and Footer
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SeatLegend(),
                      const SizedBox(height: 20),

                      // Seat chips (Mock selection)
                      if (selectedCount > 0)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.black.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '$selectedCount / ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'tickets',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.close, size: 14),
                                ],
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),

                      // Total and Pay
                      BookingPriceFooter(
                        totalPrice: state.totalPrice.toInt(),
                        onProceed: () {
                          // TODO: Implement proceed logic
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
