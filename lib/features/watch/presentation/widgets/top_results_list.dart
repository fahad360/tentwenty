import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../movie_details/presentation/pages/movie_detail_screen.dart';
import '../../domain/entities/movie_entity.dart';
import '../bloc/watch_state.dart';
import 'search_result_tile.dart';
import '../../../../core/widgets/skeleton_widgets.dart';

class TopResultsList extends StatelessWidget {
  final List<MovieEntity> results;
  final WatchStatus status;

  const TopResultsList({
    super.key,
    required this.results,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (status == WatchStatus.loading) {
      return const SkeletonSearchResultList();
    }

    if (results.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
            'Top Results',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.darkBlue,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: results.length,
            separatorBuilder: (context, index) =>
                const Divider(color: AppColors.inputFill),
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
        ),
      ],
    );
  }
}
