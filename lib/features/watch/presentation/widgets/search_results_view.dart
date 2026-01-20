import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../../movie_details/presentation/pages/movie_detail_screen.dart';
import '../../domain/entities/movie_entity.dart';
import '../bloc/watch_bloc.dart';
import '../bloc/watch_event.dart';
import 'search_result_tile.dart';

class SearchResultsView extends StatelessWidget {
  final List<MovieEntity> results;

  const SearchResultsView({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
            size: 20,
          ),
          onPressed: () {
            // Revert search submission
            context.read<WatchBloc>().add(
              SearchQueryChanged(context.read<WatchBloc>().state.searchQuery),
            );
          },
        ),
        title: Text(
          '${results.length} Results Found',
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: results.length,
        itemBuilder: (context, index) {
          return SearchResultTile(
            movie: results[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MovieDetailScreen(movie: results[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
