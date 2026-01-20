class Movie {
  final String title;
  final String imageUrl;
  final String category;
  final String overview;
  final String releaseDate;
  final List<String> genres;
  final String trailerUrl;

  Movie({
    required this.title,
    required this.imageUrl,
    required this.category,
    this.overview =
        'As a collection of history\'s worst tyrants and criminal masterminds gather to plot a war to wipe out millions, one man must race against time to stop them.',
    this.releaseDate = 'December 22, 2021',
    this.genres = const ['Action', 'Thriller', 'Science', 'Fiction'],
    this.trailerUrl = '',
  });
}
