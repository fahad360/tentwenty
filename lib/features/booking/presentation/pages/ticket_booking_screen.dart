import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../watch/domain/entities/movie_entity.dart';
// import '../../domain/entities/theater_entity.dart';
import '../../data/models/cinema_data.dart' as legacy;
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import 'seat_selection_screen.dart';
import '../../../../core/widgets/skeleton_widgets.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/date_selector.dart';
import '../widgets/showtime_card.dart';

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
        backgroundColor: AppColors.background,
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
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'In Theaters ${widget.movie.releaseDate}',
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
            if (state.status == BookingStatus.loading) {
              return const SkeletonTicketBooking();
            } else if (state.status == BookingStatus.error) {
              return Center(child: Text(state.errorMessage));
            } else if (state.status == BookingStatus.success) {
              // Flatten showtimes from all theaters
              final allShowtimes = state.theaters
                  .expand((t) => t.showtimes)
                  .toList();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DateSelector(
                      dates: _dates,
                      selectedIndex: state.selectedDateIndex,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 320,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: allShowtimes.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          return ShowtimeCard(
                            index: index,
                            showtime: allShowtimes[index],
                            isSelected: state.selectedShowtimeIndex == index,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: PrimaryButton(
                        text: 'Select Seats',
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
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 20,
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
