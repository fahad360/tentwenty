import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/movie_entity.dart';
import '../../data/models/genre.dart';
import '../bloc/watch_bloc.dart';
import '../bloc/watch_event.dart';
import '../bloc/watch_state.dart';
import '../widgets/movie_card.dart';
import '../widgets/genre_card.dart';
import '../widgets/search_result_tile.dart';
import '../../../movie_details/presentation/pages/movie_detail_screen.dart';
import '../../../../core/widgets/skeleton_widgets.dart';
import '../../../../core/theme/colors.dart';

class WatchScreen extends StatefulWidget {
  const WatchScreen({super.key});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(BuildContext context, String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 800), () {
      context.read<WatchBloc>().add(SearchQueryChanged(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WatchBloc>()..add(GetUpcomingMovies()),
      child: BlocConsumer<WatchBloc, WatchState>(
        listener: (context, state) {
          // Sync controller if needed, but usually on change is one way
          if (!state.isSearchActive && _searchController.text.isNotEmpty) {
            _searchController.clear();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: state.isSearchActive
                ? null
                : AppBar(
                    title: const Text('Watch'),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          context.read<WatchBloc>().add(ToggleSearch());
                        },
                      ),
                    ],
                  ),
            body: Builder(
              builder: (context) {
                if (state.isSearchSubmitted) {
                  if (state.status == WatchStatus.success) {
                    return _buildResultsFoundView(context, state.movies);
                  } else if (state.status == WatchStatus.loading) {
                    return const SkeletonSearchResultList();
                  } else if (state.status == WatchStatus.error) {
                    return Center(child: Text(state.errorMessage));
                  }
                }

                return state.isSearchActive
                    ? _buildSearchInputView(context, state)
                    : _buildMovieListView(context, state);
              },
            ),
          );
        },
      ),
    );
  }

  // --- View Builders ---

  Widget _buildMovieListView(BuildContext context, WatchState state) {
    if (state.status == WatchStatus.loading) {
      return const SkeletonHorizontalList();
    } else if (state.status == WatchStatus.error) {
      return Center(child: Text(state.errorMessage));
    } else if (state.status == WatchStatus.success) {
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
          itemCount: state.movies.length,
          itemBuilder: (context, index) {
            return MovieCard(movie: state.movies[index]);
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSearchInputView(BuildContext context, WatchState state) {
    bool showTopResults = state.searchQuery.isNotEmpty;
    List<MovieEntity> results = state.movies;

    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 20,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => _onSearchChanged(context, val),
              onSubmitted: (val) {
                context.read<WatchBloc>().add(SubmitSearch());
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.inputFill,
                hintText: 'TV shows, movies and more',
                hintStyle: const TextStyle(color: AppColors.greyText),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.darkPurple,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.darkPurple),
                  onPressed: () {
                    context.read<WatchBloc>().add(ToggleSearch());
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: AppColors.white,
            child: showTopResults
                ? _buildTopResultsList(state, results)
                : _buildGenreGrid(),
          ),
        ),
      ],
    );
  }

  Widget _buildGenreGrid() {
    // Mock Genres (moved locally or kept locally inside widget for now as they are static mock)
    final List<Genre> genres = [
      Genre(
        title: 'Comedies',
        imageUrl: 'https://picsum.photos/seed/comedy/400/300',
      ),
      Genre(
        title: 'Crime',
        imageUrl: 'https://picsum.photos/seed/crime/400/300',
      ),
      Genre(
        title: 'Family',
        imageUrl: 'https://picsum.photos/seed/family/400/300',
      ),
      Genre(
        title: 'Documentaries',
        imageUrl: 'https://picsum.photos/seed/documentary/400/300',
      ),
      Genre(
        title: 'Dramas',
        imageUrl: 'https://picsum.photos/seed/drama/400/300',
      ),
      Genre(
        title: 'Fantasy',
        imageUrl: 'https://picsum.photos/seed/fantasy/400/300',
      ),
      Genre(
        title: 'Holidays',
        imageUrl: 'https://picsum.photos/seed/holiday/400/300',
      ),
      Genre(
        title: 'Horror',
        imageUrl: 'https://picsum.photos/seed/horror/400/300',
      ),
      Genre(
        title: 'Sci-Fi',
        imageUrl: 'https://picsum.photos/seed/scifigenre/400/300',
      ),
      Genre(
        title: 'Thriller',
        imageUrl: 'https://picsum.photos/seed/thriller/400/300',
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.63,
      ),
      itemCount: genres.length,
      itemBuilder: (context, index) {
        return GenreCard(genre: genres[index]);
      },
    );
  }

  Widget _buildTopResultsList(WatchState state, List<MovieEntity> results) {
    if (state.status == WatchStatus.loading) {
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

  Widget _buildResultsFoundView(
    BuildContext context,
    List<MovieEntity> results,
  ) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
            size: 20,
          ),
          onPressed: () {
            // Cancel search submission via Bloc
            context.read<WatchBloc>().add(
              SearchQueryChanged(context.read<WatchBloc>().state.searchQuery),
            );
            // Or better, just toggle submission off?
            // Since we track `isSearchSubmitted`, we can have an event `CancelSearchSubmission` or reusing `SearchQueryChanged` effectively resets it based on logic.
            // Actually my logic for SearchQueryChanged sets isSearchSubmitted = false. So sending current query works.
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
