import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class WatchScreen extends StatefulWidget {
  const WatchScreen({super.key});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  // State
  bool _isSearchActive = false;
  bool _isSearchSubmitted = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  // Mock Genres (Keep local for now as no API for genres yet)
  final List<Genre> _genres = [
    Genre(
      title: 'Comedies',
      imageUrl: 'https://picsum.photos/seed/comedy/400/300',
    ),
    Genre(title: 'Crime', imageUrl: 'https://picsum.photos/seed/crime/400/300'),
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

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _toggleSearch(BuildContext context) {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
        _isSearchSubmitted = false;
        // Reset to initial state
        context.read<WatchBloc>().add(GetUpcomingMovies());
      }
    });
  }

  void _onSearchChanged(BuildContext context, String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Reset submitted state if user types again
    if (_isSearchSubmitted) {
      setState(() {
        _isSearchSubmitted = false;
      });
    }

    _debounce = Timer(const Duration(milliseconds: 800), () {
      if (query.isNotEmpty) {
        context.read<WatchBloc>().add(SearchMovies(query));
      } else {
        context.read<WatchBloc>().add(GetUpcomingMovies());
      }
    });
  }

  void _onSearchSubmitted(BuildContext context, String query) {
    if (query.isEmpty) return;
    setState(() {
      _isSearchSubmitted = true;
    });
    context.read<WatchBloc>().add(SearchMovies(query));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WatchBloc>()..add(GetUpcomingMovies()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: _isSearchActive
                ? null
                : AppBar(
                    title: const Text('Watch'),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => _toggleSearch(context),
                      ),
                    ],
                  ),
            body: BlocBuilder<WatchBloc, WatchState>(
              builder: (context, state) {
                if (_isSearchSubmitted) {
                  if (state is WatchLoaded) {
                    return _buildResultsFoundView(context, state.movies);
                  } else if (state is WatchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WatchError) {
                    return Center(child: Text(state.message));
                  }
                }

                return _isSearchActive
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
    if (state is WatchLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is WatchError) {
      return Center(child: Text(state.message));
    } else if (state is WatchLoaded) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<WatchBloc>().add(GetUpcomingMovies());
        },
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
    bool showTopResults = _searchController.text.isNotEmpty;

    // If we are searching, check if we have results
    List<MovieEntity> results = [];
    if (state is WatchLoaded) {
      results = state.movies;
    }

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
              onSubmitted: (val) => _onSearchSubmitted(context, val),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFEFEFEF),
                hintText: 'TV shows, movies and more',
                hintStyle: const TextStyle(color: Color(0xFF827D88)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2E2739)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF2E2739)),
                  onPressed: () => _toggleSearch(context),
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
            color: const Color(0xFFFFFFFF),
            child: showTopResults
                ? _buildTopResultsList(state, results)
                : _buildGenreGrid(),
                
          ),
        ),
      ],
    );
  }

  Widget _buildGenreGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.63,
      ),
      itemCount: _genres.length,
      itemBuilder: (context, index) {
        return GenreCard(genre: _genres[index]);
      },
    );
  }

  Widget _buildTopResultsList(WatchState state, List<MovieEntity> results) {
    if (state is WatchLoading) {
      return const Center(child: CircularProgressIndicator());
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
              color: Color(0xFF202C43),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: results.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Color(0xFFEFEFEF)),
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            setState(() {
              _isSearchSubmitted = false;
            });
            // Revert to search active state visuals with previous query
            // Ideally we re-fetch if needed or keep state
          },
        ),
        title: Text(
          '${results.length} Results Found',
          style: const TextStyle(
            color: Colors.black,
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
