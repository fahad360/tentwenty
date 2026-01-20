import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_model.dart';
import '../entities/movie_entity.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieEntity>>> getUpcomingMovies();
  Future<Either<Failure, List<MovieEntity>>> searchMovies(String query);
  Future<Either<Failure, MovieEntity>> getMovieDetails(int id);
}
