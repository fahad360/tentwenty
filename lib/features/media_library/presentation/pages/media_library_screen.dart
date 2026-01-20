import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tentwenty/features/media_library/presentation/bloc/favorites_event.dart';
import 'package:tentwenty/features/media_library/presentation/bloc/favorites_state.dart';
import '../../../../injection_container.dart';
import '../bloc/favorites_bloc.dart';
import '../../../../core/widgets/skeleton_widgets.dart';
import '../../../../core/theme/colors.dart';
import '../widgets/media_library_list.dart';

class MediaLibraryScreen extends StatelessWidget {
  const MediaLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FavoritesBloc>()..add(LoadFavorites()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Media Library',
            style: TextStyle(color: AppColors.black),
          ),
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: const BackButton(color: AppColors.black),
        ),
        body: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return const SkeletonMediaLibraryList();
            } else if (state is FavoritesError) {
              return Center(child: Text(state.message));
            } else if (state is FavoritesLoaded) {
              if (state.movies.isEmpty) {
                return const Center(child: Text('No favorites yet'));
              }
              return MediaLibraryList(movies: state.movies);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
