import '../models/theater_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<TheaterModel>> getTheatersForMovie(int movieId, String date);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  // Mock Data
  final List<TheaterModel> _mockTheaters = const [
    TheaterModel(
      name: 'Cinetech + Hall 1',
      location: '123 Test St',
      showtimesModel: [
        ShowtimeModel(
          time: '12:30',
          hall: 'Cinetech + Hall 1',
          price: 50,
          bonusPoints: 2500,
        ),
        ShowtimeModel(
          time: '13:30',
          hall: 'Cinetech + Hall 2',
          price: 75,
          bonusPoints: 3000,
        ),
      ],
    ),
    TheaterModel(
      name: 'Cinetech + Hall 2',
      location: '456 Test Ave',
      showtimesModel: [
        ShowtimeModel(
          time: '12:30',
          hall: 'Cinetech + Hall 2',
          price: 75,
          bonusPoints: 3000,
        ),
      ],
    ),
  ];

  @override
  Future<List<TheaterModel>> getTheatersForMovie(
    int movieId,
    String date,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTheaters;
  }
}
