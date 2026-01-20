import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_model.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/entities/movie_entity.dart';
import '../datasources/movie_service.dart';
import '../../domain/entities/video_entity.dart';
import '../../../../core/database/database_helper.dart';

import 'dart:async';

class MovieRepositoryImpl implements MovieRepository {
  final MovieService _movieService;
  final _favoritesController = StreamController<void>.broadcast();

  MovieRepositoryImpl(this._movieService);

  @override
  Stream<void> get onFavoritesChanged => _favoritesController.stream;

  @override
  Future<Either<Failure, List<MovieEntity>>> getUpcomingMovies() async {
    try {
      final movieResponse = await _movieService.getUpcomingMovies();
      return Right(movieResponse.results);
    } catch (e) {
      // Fallback to offline favorites
      try {
        final localMovies = await DatabaseHelper().getFavorites();
        if (localMovies.isNotEmpty) {
          return Right(localMovies);
        }
      } catch (_) {}
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> searchMovies(String query) async {
    try {
      final movieResponse = await _movieService.searchMovies(query);
      return Right(movieResponse.results);
    } on Exception catch (e) {
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

  @override
  Future<Either<Failure, List<VideoEntity>>> getMovieTrailers(int id) async {
    try {
      final response = await _movieService.getMovieVideos(id);
      return Right(response.results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveMovieInFavorites(MovieEntity movie) async {
    try {
      await DatabaseHelper().insertMovie(movie);
      _favoritesController.add(null);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeMovieFromFavorites(int id) async {
    try {
      await DatabaseHelper().removeMovie(id);
      _favoritesController.add(null);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<bool> isMovieFavorite(int id) async {
    try {
      return await DatabaseHelper().isFavorite(id);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getFavoriteMovies() async {
    try {
      final movies = await DatabaseHelper().getFavorites();
      return Right(movies);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
