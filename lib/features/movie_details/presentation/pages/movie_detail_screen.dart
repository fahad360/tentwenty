import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../../features/watch/domain/entities/movie_entity.dart';
import '../../../../injection_container.dart';
import '../bloc/movie_detail_bloc.dart';
import '../bloc/movie_detail_event.dart';
import '../bloc/movie_detail_state.dart';
import 'video_player_screen.dart';
import '../../../../core/widgets/skeleton_widgets.dart';
import '../../../../core/theme/colors.dart';
import '../widgets/movie_hero_header.dart';
import '../widgets/movie_content.dart';

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
            MovieHeroHeader(movie: movie, isPortrait: true),
            MovieContent(movie: movie),
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
          child: MovieHeroHeader(movie: movie, isPortrait: false),
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
                child: MovieContent(movie: movie),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
