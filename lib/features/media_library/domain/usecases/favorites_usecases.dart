import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_model.dart';
import '../../../../features/watch/domain/entities/movie_entity.dart';
import '../../../../features/watch/domain/repositories/movie_repository.dart';

class SaveMovieUseCase {
  final MovieRepository repository;

  SaveMovieUseCase(this.repository);

  Future<Either<Failure, void>> call(MovieEntity movie) async {
    return await repository.saveMovieInFavorites(movie);
  }
}

class RemoveMovieUseCase {
  final MovieRepository repository;

  RemoveMovieUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.removeMovieFromFavorites(id);
  }
}

class GetFavoritesUseCase {
  final MovieRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<Either<Failure, List<MovieEntity>>> call() async {
    return await repository.getFavoriteMovies();
  }
}

class IsMovieFavoriteUseCase {
  final MovieRepository repository;

  IsMovieFavoriteUseCase(this.repository);

  Future<bool> call(int id) async {
    return await repository.isMovieFavorite(id);
  }
}
