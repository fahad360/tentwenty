import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_model.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MovieEntity>>> getUpcomingMovies() async {
    try {
      final remoteMovies = await remoteDataSource.getUpcomingMovies();
      return Right(remoteMovies);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> searchMovies(String query) async {
    try {
      final remoteMovies = await remoteDataSource.searchMovies(query);
      return Right(remoteMovies);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
