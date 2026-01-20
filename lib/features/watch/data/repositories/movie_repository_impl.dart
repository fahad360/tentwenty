import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_model.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_service.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieService _movieService;

  MovieRepositoryImpl(this._movieService);

  @override
  Future<Either<Failure, List<MovieEntity>>> getUpcomingMovies() async {
    try {
      final response = await _movieService.getUpcomingMovies();
      return Right(response.results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> searchMovies(String query) async {
    try {
      final response = await _movieService.searchMovies(query);
      return Right(response.results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovieEntity>> getMovieDetails(int id) async {
    try {
      final movieModel = await _movieService.getMovieDetails(id);
      return Right(movieModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
