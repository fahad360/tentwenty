import 'package:get_it/get_it.dart';
import 'core/client/dio_client.dart';
import 'features/watch/data/datasources/movie_service.dart';
import 'features/watch/data/repositories/movie_repository_impl.dart';
import 'features/watch/domain/repositories/movie_repository.dart';
import 'features/watch/domain/usecases/get_upcoming_movies_usecase.dart';
import 'features/watch/domain/usecases/search_movies_usecase.dart';
import 'features/watch/presentation/bloc/watch_bloc.dart';
import 'features/booking/data/datasources/booking_remote_data_source.dart';
import 'features/booking/data/repositories/booking_repository_impl.dart';
import 'features/booking/domain/repositories/booking_repository.dart';
import 'features/booking/domain/usecases/get_movie_showtimes_usecase.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';
import 'features/movie_details/domain/usecases/get_movie_details_usecase.dart';
import 'features/movie_details/domain/usecases/get_movie_trailers_usecase.dart';
import 'features/movie_details/presentation/bloc/movie_detail_bloc.dart';
import 'features/media_library/domain/usecases/favorites_usecases.dart';
import 'features/media_library/presentation/bloc/favorites_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton(() => DioClient());

  // Features - Watch
  // Bloc
  sl.registerFactory(
    () => WatchBloc(getUpcomingMoviesUseCase: sl(), searchMoviesUseCase: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetUpcomingMoviesUseCase(sl()));
  sl.registerLazySingleton(() => SearchMoviesUseCase(sl()));

  // Repository
  sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(sl()));

  // Services
  sl.registerLazySingleton(() => MovieService(sl<DioClient>().dio));

  // Features - Booking
  // Bloc
  sl.registerFactory(() => BookingBloc(getMovieShowtimesUseCase: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetMovieShowtimesUseCase(sl()));

  // Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(sl()),
  );

  // Data Sources
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(),
  );

  // Features - Movie Details
  // Bloc
  sl.registerFactory(
    () => MovieDetailBloc(
      getMovieDetailsUseCase: sl(),
      getMovieTrailersUseCase: sl(),
      saveMovieUseCase: sl(),
      removeMovieUseCase: sl(),
      isMovieFavoriteUseCase: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => GetMovieDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetMovieTrailersUseCase(sl()));

  // Features - Media Library / Favorites
  sl.registerFactory(
    () => FavoritesBloc(getFavoritesUseCase: sl(), repository: sl(), removeMovieUseCase: sl()),
  );
  sl.registerLazySingleton(() => SaveMovieUseCase(sl()));
  sl.registerLazySingleton(() => RemoveMovieUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => IsMovieFavoriteUseCase(sl()));
}
