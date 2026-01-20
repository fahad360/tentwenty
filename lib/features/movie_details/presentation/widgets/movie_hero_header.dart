import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../../../features/watch/domain/entities/movie_entity.dart';
import '../../../../features/booking/presentation/pages/ticket_booking_screen.dart';
import '../bloc/movie_detail_bloc.dart';
import '../bloc/movie_detail_event.dart';

class MovieHeroHeader extends StatelessWidget {
  final MovieEntity movie;
  final bool isPortrait;

  const MovieHeroHeader({
    super.key,
    required this.movie,
    required this.isPortrait,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isPortrait ? 500 : double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkerGrey,
        image: movie.imageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(movie.imageUrl),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {},
              )
            : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.black.withValues(alpha: 0.3),
              AppColors.transparent,
              AppColors.black.withValues(alpha: 0.8),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'In Theaters ${movie.releaseDate}',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),
            if (isPortrait)
              Column(
                children: [
                  SizedBox(
                    width: 260,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TicketBookingScreen(movie: movie),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Get Tickets',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 260,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<MovieDetailBloc>().add(
                          WatchTrailer(movie.id),
                        );
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        color: AppColors.white,
                      ),
                      label: const Text(
                        'Watch Trailer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.lightBlue,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TicketBookingScreen(movie: movie),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Get Tickets',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<MovieDetailBloc>().add(
                            WatchTrailer(movie.id),
                          );
                        },
                        icon: const Icon(
                          Icons.play_arrow,
                          color: AppColors.white,
                        ),
                        label: const Text(
                          'Watch Trailer',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.lightBlue,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
