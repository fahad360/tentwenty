import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/movie_model.dart';
import '../models/video_model.dart';
import '../../../../core/constants/constants.dart';

part 'movie_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class MovieService {
  factory MovieService(Dio dio, {String baseUrl}) = _MovieService;

  @GET('movie/upcoming')
  Future<MovieResponse> getUpcomingMovies();

  @GET('search/movie')
  Future<MovieResponse> searchMovies(@Query('query') String query);

  @GET('movie/{id}')
  Future<MovieModel> getMovieDetails(@Path('id') int id);

  @GET('movie/{id}/videos')
  Future<VideoResponse> getMovieVideos(@Path('id') int id);
}
