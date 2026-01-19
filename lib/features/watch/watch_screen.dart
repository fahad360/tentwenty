import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'models/genre.dart';
import 'models/movie.dart';
import 'widgets/genre_card.dart';
import 'widgets/movie_card.dart';
import 'widgets/search_result_tile.dart';

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
  List<Movie> _searchResults = [];
  Timer? _debounce;

  // Data
  final List<Movie> _movies = [
    Movie(
      title: 'Free Guy',
      imageUrl: 'https://picsum.photos/seed/freeguy/800/600',
      category: 'Fantasy',
    ),
    Movie(
      title: 'The King\'s Man',
      imageUrl: 'https://picsum.photos/seed/kingsman/800/600',
      category: 'Action',
    ),
    Movie(
      title: 'Jojo Rabbit',
      imageUrl: 'https://picsum.photos/seed/jojorabbit/800/600',
      category: 'Drama',
    ),
    Movie(
      title: 'Sci-Fi Hits',
      imageUrl: 'https://picsum.photos/seed/scifi/800/600',
      category: 'Sci-Fi',
    ),
    // Extra movies for search demo
    Movie(
      title: 'Time to Hunt',
      imageUrl: 'https://picsum.photos/seed/timetohunt/800/600',
      category: 'Thriller',
    ),
    Movie(
      title: 'In Time',
      imageUrl: 'https://picsum.photos/seed/intime/800/600',
      category: 'Sci-Fi',
    ),
    Movie(
      title: 'A Time to Kill',
      imageUrl: 'https://picsum.photos/seed/atimetokill/800/600',
      category: 'Crime',
    ),
  ];

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

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
        _isSearchSubmitted = false;
        _searchResults.clear();
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Reset submitted state if user types again
    if (_isSearchSubmitted) {
      setState(() {
        _isSearchSubmitted = false;
      });
    }

    _debounce = Timer(const Duration(milliseconds: 800), () {
      if (query.isNotEmpty) {
        setState(() {
          // Simple mock filter
          _searchResults = _movies.where((movie) {
            return movie.title.toLowerCase().contains(query.toLowerCase());
          }).toList();
        });
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  void _onSearchSubmitted(String query) {
    if (query.isEmpty) return;
    setState(() {
      _isSearchSubmitted = true;
      // Ensure results are up to date immediately on submit without wait
      _searchResults = _movies.where((movie) {
        return movie.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 3 Main Views:
    // 1. Search Submitted (New Screen look)
    // 2. Search Active (Search Bar + (Grid OR Top Results))
    // 3. Normal List Helper

    if (_isSearchSubmitted) {
      return _buildResultsFoundView();
    }

    return Scaffold(
      appBar: _isSearchActive
          ? null
          : AppBar(
              title: const Text('Watch'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _toggleSearch,
                ),
              ],
            ),
      body: _isSearchActive ? _buildSearchInputView() : _buildMovieListView(),
    );
  }

  // --- View Builders ---

  Widget _buildMovieListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _movies.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: _movies[index]);
      },
    );
  }

  Widget _buildSearchInputView() {
    bool showTopResults = _searchController.text.isNotEmpty;

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
              onChanged: _onSearchChanged,
              onSubmitted: _onSearchSubmitted,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFEFEFEF),
                hintText: 'TV shows, movies and more',
                hintStyle: const TextStyle(color: Color(0xFF827D88)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2E2739)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF2E2739)),
                  onPressed: _toggleSearch,
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
            color: const Color(0xFFF2F2F6),
            child: showTopResults ? _buildTopResultsList() : _buildGenreGrid(),
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

  Widget _buildTopResultsList() {
    if (_searchResults.isEmpty) {
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
            itemCount: _searchResults.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Color(0xFFEFEFEF)),
            itemBuilder: (context, index) {
              return SearchResultTile(movie: _searchResults[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultsFoundView() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            setState(() {
              _isSearchSubmitted = false;
            });
          },
        ),
        title: Text(
          '${_searchResults.length} Results Found',
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
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          return SearchResultTile(movie: _searchResults[index]);
        },
      ),
    );
  }
}
