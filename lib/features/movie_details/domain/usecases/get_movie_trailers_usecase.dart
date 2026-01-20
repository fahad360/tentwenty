import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_model.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../watch/domain/entities/video_entity.dart';
import '../../../watch/domain/repositories/movie_repository.dart';

class GetMovieTrailersUseCase implements UseCase<List<VideoEntity>, int> {
  final MovieRepository _repository;

  GetMovieTrailersUseCase(this._repository);

  @override
  Future<Either<Failure, List<VideoEntity>>> call(int params) {
    return _repository.getMovieTrailers(params);
  }
}
