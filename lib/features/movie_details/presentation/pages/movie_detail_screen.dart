import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../../features/watch/domain/entities/movie_entity.dart';
import '../../../../features/booking/presentation/pages/ticket_booking_screen.dart';
import '../../../../injection_container.dart';
import '../bloc/movie_detail_bloc.dart';
import '../bloc/movie_detail_event.dart';
import '../bloc/movie_detail_state.dart';
import 'video_player_screen.dart';
import '../../../../core/widgets/skeleton_widgets.dart';
import '../../../../core/theme/colors.dart';

class MovieDetailScreen extends StatefulWidget {
  final MovieEntity movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<MovieDetailBloc>()..add(GetMovieDetails(widget.movie.id)),
      child: BlocConsumer<MovieDetailBloc, MovieDetailState>(
        listener: (context, state) {
          if (state is MovieTrailerLoaded) {
            // ... (existing listener logic)
            final videos = state.videos;
            final trailer =
                videos.firstWhereOrNull(
                  (v) => v.site == 'YouTube' && v.type == 'Trailer',
                ) ??
                videos.firstWhereOrNull((v) => v.site == 'YouTube');

            if (trailer != null && trailer.key.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(videoId: trailer.key),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No trailer available')),
              );
            }
          } else if (state is MovieDetailError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.black,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: const SkeletonDetailScreen(),
            );
          }
          final movie = state is MovieDetailLoaded ? state.movie : widget.movie;

          bool isFavorite = false;
          if (state is MovieDetailLoaded) {
            isFavorite = state.isFavorite;
          }

          bool isLandscape =
              MediaQuery.of(context).orientation == Orientation.landscape;

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: AppColors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'Watch',
                style: TextStyle(color: AppColors.white),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? AppColors.red : AppColors.white,
                  ),
                  onPressed: () {
                    // We need to pass the movie entity.
                    // If we have detailed movie from state, use it, else widget.movie
                    context.read<MovieDetailBloc>().add(ToggleFavorite(movie));
                  },
                ),
              ],
            ),
            body: isLandscape
                ? _buildLandscapeLayout(context, movie)
                : _buildPortraitLayout(context, movie),
          );
        },
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, MovieEntity movie) {
    return LiquidPullToRefresh(
      onRefresh: () async {
        context.read<MovieDetailBloc>().add(GetMovieDetails(movie.id));
      },
      color: AppColors.lightBlue, // Accent Color
      backgroundColor: AppColors.white,
      height: 60,
      showChildOpacityTransition: false,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroHeader(context, movie, isPortrait: true),
            _buildContent(context, movie),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, MovieEntity movie) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 1,
          child: _buildHeroHeader(context, movie, isPortrait: false),
        ),
        Expanded(
          flex: 1,
          child: LiquidPullToRefresh(
            onRefresh: () async {
              context.read<MovieDetailBloc>().add(GetMovieDetails(movie.id));
            },
            color: AppColors.lightBlue,
            backgroundColor: AppColors.white,
            height: 60,
            showChildOpacityTransition: false,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                child: _buildContent(context, movie),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroHeader(
    BuildContext context,
    MovieEntity movie, {
    required bool isPortrait,
  }) {
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
                    width: 243,
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
                    width: 243,
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
                            fontSize: 16,
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
                  ),
                ],
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MovieEntity movie) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Genres',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: movie.genres
                .map((genre) => _buildGenreChip(genre))
                .toList(),
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.lightGrey),
          const SizedBox(height: 20),
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            movie.overview,
            style: const TextStyle(
              fontSize: 12,
              height: 1.5,
              color: AppColors.greyLabel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreChip(String label) {
    Color chipColor;
    switch (label) {
      case 'Action':
        chipColor = AppColors.teal;
        break;
      case 'Thriller':
        chipColor = AppColors.pink;
        break;
      case 'Science':
        chipColor = AppColors.seatVip; // purple
        break;
      case 'Fiction':
        chipColor = AppColors.seatSelected; // gold
        break;
      default:
        chipColor = AppColors.grey; // Default color for unknown genres
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
