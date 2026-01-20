import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/movie_entity.dart';
import '../bloc/watch_bloc.dart';
import '../bloc/watch_event.dart';
import 'movie_card.dart';

class MovieList extends StatelessWidget {
  final List<MovieEntity> movies;

  const MovieList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: () async {
        context.read<WatchBloc>().add(GetUpcomingMovies());
      },
      color: AppColors.lightBlue,
      backgroundColor: AppColors.white,
      height: 60,
      showChildOpacityTransition: false,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return MovieCard(movie: movies[index]);
        },
      ),
    );
  }
}
