import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/watch_bloc.dart';
import '../bloc/watch_event.dart';
import '../bloc/watch_state.dart';
import '../widgets/watch_search_bar.dart';
import '../widgets/genre_grid.dart';
import '../widgets/movie_list.dart';
import '../widgets/top_results_list.dart';
import '../widgets/search_results_view.dart';
import '../../../../core/widgets/skeleton_widgets.dart';

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
                    return SearchResultsView(results: state.movies);
                  } else if (state.status == WatchStatus.loading) {
                    return const SkeletonSearchResultList();
                  } else if (state.status == WatchStatus.error) {
                    return Center(child: Text(state.errorMessage));
                  }
                }

                return state.isSearchActive
                    ? Column(
                        children: [
                          SafeArea(
                            bottom: false,
                            child: WatchSearchBar(
                              controller: _searchController,
                              onChanged: (val) =>
                                  _onSearchChanged(context, val),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              child: state.searchQuery.isNotEmpty
                                  ? TopResultsList(
                                      results: state.movies,
                                      status: state.status,
                                    )
                                  : const GenreGrid(),
                            ),
                          ),
                        ],
                      )
                    : _buildMovieListView(context, state);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieListView(BuildContext context, WatchState state) {
    if (state.status == WatchStatus.loading) {
      return const SkeletonHorizontalList();
    } else if (state.status == WatchStatus.error) {
      return Center(child: Text(state.errorMessage));
    } else if (state.status == WatchStatus.success) {
      return MovieList(movies: state.movies);
    }
    return const SizedBox.shrink();
  }
}
