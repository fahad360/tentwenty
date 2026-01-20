import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_model.dart';
import '../entities/movie_entity.dart';
import '../entities/video_entity.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieEntity>>> getUpcomingMovies();
  Future<Either<Failure, List<MovieEntity>>> searchMovies(String query);
  Future<Either<Failure, MovieEntity>> getMovieDetails(int id);
  Future<Either<Failure, List<VideoEntity>>> getMovieTrailers(int id);
}
