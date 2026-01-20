import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getUpcomingMovies();
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  // Mock Data
  final List<MovieModel> _mockMovies = [
    const MovieModel(
      id: 1,
      title: 'Free Guy',
      imageUrl: 'https://picsum.photos/seed/freeguy/800/600',
      category: 'Fantasy',
      overview:
          'A bank teller discovers he is actually a background player in an open-world video game, and decides to become the hero of his own story...one he rewrites himself.',
      releaseDate: 'December 11, 2020',
      genres: ['Action', 'Comedy', 'Science', 'Fiction'],
      trailerUrl: 'https://www.youtube.com/watch?v=X2m-08cOAbc',
    ),
    const MovieModel(
      id: 2,
      title: 'The King\'s Man',
      imageUrl: 'https://picsum.photos/seed/kingsman/800/600',
      category: 'Action',
      overview:
          'As a collection of history\'s worst tyrants and criminal masterminds gather to plot a war to wipe out millions, one man must race against time to stop them. Discover the origins of the very first independent intelligence agency in The King\'s Man. The Comic Book "The Secret Service" by Mark Millar and Dave Gibbons.',
      releaseDate: 'December 22, 2021',
      genres: ['Action', 'Thriller', 'Science', 'Fiction'],
      trailerUrl: 'https://www.youtube.com/watch?v=5IPy70I2jRI',
    ),
    const MovieModel(
      id: 3,
      title: 'Jojo Rabbit',
      imageUrl: 'https://picsum.photos/seed/jojorabbit/800/600',
      category: 'Drama',
      overview:
          'A World War II satire that follows a lonely German boy whose world view is turned upside down when he discovers his single mother is hiding a young Jewish girl in their attic.',
      releaseDate: 'October 18, 2019',
      genres: ['Drama', 'Comedy', 'War'],
      trailerUrl: 'https://www.youtube.com/watch?v=tL4McUzXfFI',
    ),
    const MovieModel(
      id: 4,
      title: 'Sci-Fi Hits',
      imageUrl: 'https://picsum.photos/seed/scifi/800/600',
      category: 'Sci-Fi',
      overview:
          'A compilation of the greatest sci-fi hits of the decade, featuring mind-bending visual effects and gripping storylines.',
      releaseDate: 'Various',
      genres: ['Sci-Fi', 'Adventure'],
    ),

    const MovieModel(
      id: 5,
      title: 'The Matrix',
      imageUrl: 'https://picsum.photos/seed/matrix/800/600',
      category: 'Sci-Fi',
      overview:
          'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.',
      releaseDate: 'March 19, 1999',
      genres: ['Action', 'Sci-Fi'],
      trailerUrl: 'https://www.youtube.com/watch?v=vKQi3QMEH8U',
    ),
    const MovieModel(
      id: 6,
      title: 'Inception',
      imageUrl: 'https://picsum.photos/seed/inception/800/600',
      category: 'Sci-Fi',
      overview:
          'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
      releaseDate: 'July 16, 2010',
      genres: ['Action', 'Adventure', 'Sci-Fi'],
      trailerUrl: 'https://www.youtube.com/watch?v=YoHD9XEIncY',
    ),
    const MovieModel(
      id: 7,
      title: 'The Dark Knight',
      imageUrl: 'https://picsum.photos/seed/darkknight/800/600',
      category: 'Action',
      overview:
          'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
      releaseDate: 'July 18, 2008',
      genres: ['Action', 'Crime', 'Drama'],
      trailerUrl: 'https://www.youtube.com/watch?v=EXeTwQWjf5g',
    ),
    const MovieModel(
      id: 8,
      title: 'Pulp Fiction',
      imageUrl: 'https://picsum.photos/seed/pulpfiction/800/600',
      category: 'Crime',
      overview:
          'The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.',
      releaseDate: 'October 14, 1994',
      genres: ['Crime', 'Drama'],
      trailerUrl: 'https://www.youtube.com/watch?v=tGqbjStVenI',
    ),
    const MovieModel(
      id: 9,
      title: 'The Godfather',
      imageUrl: 'https://picsum.photos/seed/godfather/800/600',
      category: 'Crime',
      overview:
          'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
      releaseDate: 'March 24, 1972',
      genres: ['Crime', 'Drama'],
      trailerUrl: 'https://www.youtube.com/watch?v=sY1S3497KTU',
    ),
    const MovieModel(
      id: 10,
      title: 'Forrest Gump',
      imageUrl: 'https://picsum.photos/seed/forrestgump/800/600',
      category: 'Drama',
      overview:
          'The presidencies of Kennedy and Johnson, the Vietnam War, the Watergate scandal and other historical events unfold from the perspective of an Alabama man with a low IQ.',
      releaseDate: 'July 6, 1994',
      genres: ['Drama', 'Romance'],
      trailerUrl: 'https://www.youtube.com/watch?v=bLvqoWEq07I',
    ),
    const MovieModel(
      id: 11,
      title: 'The Lion King',
      imageUrl: 'https://picsum.photos/seed/lionking/800/600',
      category: 'Animation',
      overview:
          'Lion prince Simba is exiled from his kingdom after the tragic death of his father, Mufasa, and must learn to take his rightful place as king.',
      releaseDate: 'June 23, 1994',
      genres: ['Animation', 'Adventure', 'Drama'],
      trailerUrl: 'https://www.youtube.com/watch?v=4smZAy3HDiU',
    ),
    const MovieModel(
      id: 12,
      title: 'Toy Story',
      imageUrl: 'https://picsum.photos/seed/toystory/800/600',
      category: 'Animation',
      overview:
          'A cowboy doll is profoundly threatened and嫉妒 when a new spaceman action figure supplants him as top toy, but the possibility of danger forces them to put their differences aside.',
      releaseDate: 'November 22, 1995',
      genres: ['Animation', 'Adventure', 'Comedy'],
      trailerUrl: 'https://www.youtube.com/watch?v=v-PtvIR5s9M',
    ),
    const MovieModel(
      id: 13,
      title: 'The Matrix Reloaded',
      imageUrl: 'https://picsum.photos/seed/matrixreloaded/800/600',
      category: 'Sci-Fi',
      overview:
          'Neo and the rebel leaders prepare for a final battle against the machines, as Neo tries to understand his role in the war.',
      releaseDate: 'May 15, 2003',
      genres: ['Action', 'Sci-Fi'],
      trailerUrl: 'https://www.youtube.com/watch?v=2N0tgUtitoQ',
    ),
    const MovieModel(
      id: 14,
      title: 'The Matrix Revolutions',
      imageUrl: 'https://picsum.photos/seed/matrixrevolutions/800/600',
      category: 'Sci-Fi',
      overview:
          'The human city of Zion defends itself against the massive invasion of the machines as Neo fights to end the war at the Source.',
      releaseDate: 'November 5, 2003',
      genres: ['Action', 'Sci-Fi'],
      trailerUrl: 'https://www.youtube.com/watch?v=0j0fzlCMUOI',
    ),
    const MovieModel(
      id: 15,
      title: 'The Lord of the Rings: The Fellowship of the Ring',
      imageUrl: 'https://picsum.photos/seed/lotr1/800/600',
      category: 'Fantasy',
      overview:
          'A young hobbit, Frodo Baggins, inherits a powerful ring that could destroy Middle-earth if it falls into the hands of the Dark Lord Sauron.',
      releaseDate: 'December 19, 2001',
      genres: ['Adventure', 'Drama', 'Fantasy'],
      trailerUrl: 'https://www.youtube.com/watch?v=V75dMMIW-ch',
    ),
    const MovieModel(
      id: 16,
      title: 'The Lord of the Rings: The Two Towers',
      imageUrl: 'https://picsum.photos/seed/lotr2/800/600',
      category: 'Fantasy',
      overview:
          'Gandalf and Aragorn lead the Free Peoples of Middle-earth against the growing power of the Dark Lord Sauron and his forces.',
      releaseDate: 'December 18, 2002',
      genres: ['Adventure', 'Drama', 'Fantasy'],
      trailerUrl: 'https://www.youtube.com/watch?v=LRLdhFVq-tg',
    ),
    const MovieModel(
      id: 17,
      title: 'The Lord of the Rings: The Return of the King',
      imageUrl: 'https://picsum.photos/seed/lotr3/800/600',
      category: 'Fantasy',
      overview:
          'The final battle for Middle-earth begins as Frodo and Sam approach Mount Doom to destroy the One Ring.',
      releaseDate: 'December 17, 2003',
      genres: ['Adventure', 'Drama', 'Fantasy'],
      trailerUrl: 'https://www.youtube.com/watch?v=r5XUN43GmcY',
    ),
  ];

  @override
  Future<List<MovieModel>> getUpcomingMovies() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    return _mockMovies;
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.isEmpty) return [];
    return _mockMovies
        .where((m) => m.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
