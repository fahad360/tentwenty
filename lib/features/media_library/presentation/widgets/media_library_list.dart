import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/favorites_bloc.dart';
import 'media_library_list_item.dart';
import '../../../watch/domain/entities/movie_entity.dart';

class MediaLibraryList extends StatelessWidget {
  final List<MovieEntity> movies;

  const MediaLibraryList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: () async {
        context.read<FavoritesBloc>().add(LoadFavorites());
      },
      color: AppColors.lightBlue,
      backgroundColor: AppColors.white,
      height: 60,
      showChildOpacityTransition: false,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return MediaLibraryListItem(movie: movies[index]);
        },
      ),
    );
  }
}
