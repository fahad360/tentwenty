import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/error_model.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/theater_entity.dart';
import '../repositories/booking_repository.dart';

class GetMovieShowtimesParams extends Equatable {
  final int movieId;
  final String date;

  const GetMovieShowtimesParams({required this.movieId, required this.date});

  @override
  List<Object?> get props => [movieId, date];
}

class GetMovieShowtimesUseCase
    implements UseCase<List<TheaterEntity>, GetMovieShowtimesParams> {
  final BookingRepository repository;

  GetMovieShowtimesUseCase(this.repository);

  @override
  Future<Either<Failure, List<TheaterEntity>>> call(
    GetMovieShowtimesParams params,
  ) async {
    return await repository.getTheatersForMovie(params.movieId, params.date);
  }
}
