import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../watch/domain/entities/movie_entity.dart';
import '../../data/models/cinema_data.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_state.dart';
import '../bloc/booking_event.dart';
import '../../../../core/theme/colors.dart';

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

  void _zoomIn() {
    final matrix = _transformationController.value;
    final currentScale = matrix.getMaxScaleOnAxis();
    if (currentScale < 3.0) {
      final zoomFactor = 1.2;
      final zoomedMatrix = matrix.clone()..scale(zoomFactor);
      _transformationController.value = zoomedMatrix;
    }
  }

  void _zoomOut() {
    final matrix = _transformationController.value;
    final currentScale = matrix.getMaxScaleOnAxis();
    if (currentScale > 0.5) {
      final zoomFactor = 0.8;
      final zoomedMatrix = matrix.clone()..scale(zoomFactor);
      _transformationController.value = zoomedMatrix;
    }
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

          return Column(
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
                        // Screen Curve
                        CustomPaint(
                          size: const Size(400, 50),
                          painter: ScreenPainter(),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "SCREEN",
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.greyLabel,
                          ),
                        ),
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
                                  return _buildSeatItem(
                                    context,
                                    state.seats[i][j],
                                  );
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20, bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _zoomIn,
                        ),
                        const Divider(height: 1),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _zoomOut,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

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
                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLegendItem(AppColors.seatSelected, 'Selected'),
                        _buildLegendItem(AppColors.seatTaken, 'Not available'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLegendItem(AppColors.seatVip, 'VIP (150\$)'),
                        _buildLegendItem(
                          AppColors.seatRegular,
                          'Regular (50 \$)',
                        ),
                      ],
                    ),
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
                    Row(
                      children: [
                        Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.black.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Price',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.greyLabel,
                                ),
                              ),
                              Text(
                                '\$ ${state.totalPrice.toInt()}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: SizedBox(
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.lightBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Proceed to pay',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSeatItem(BuildContext context, Seat seat) {
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

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/svgs/seat.svg',
          width: 20,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.greyLabel,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class ScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height);

    canvas.drawPath(path, paint);

    // Shadow effect
    final shadowPaint = Paint()
      ..color = AppColors.lightBlue.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final shadowPath = Path();
    shadowPath.moveTo(0, size.height);
    shadowPath.quadraticBezierTo(size.width / 2, 0, size.width, size.height);
    shadowPath.lineTo(size.width, size.height + 20);
    shadowPath.lineTo(0, size.height + 20);
    shadowPath.close();

    canvas.drawPath(shadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
