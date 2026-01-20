import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_model.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../watch/domain/entities/movie_entity.dart';
import '../../../watch/domain/repositories/movie_repository.dart';

class GetMovieDetailsUseCase implements UseCase<MovieEntity, int> {
  final MovieRepository _repository;

  GetMovieDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, MovieEntity>> call(int params) {
    return _repository.getMovieDetails(params);
  }
}
