import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_model.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetUpcomingMoviesUseCase implements UseCase<List<MovieEntity>, NoParams> {
  final MovieRepository repository;

  GetUpcomingMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MovieEntity>>> call(NoParams params) async {
    return await repository.getUpcomingMovies();
  }
}
