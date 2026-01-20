import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_model.dart';
import '../../domain/entities/theater_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<TheaterEntity>>> getTheatersForMovie(
    int movieId,
    String date,
  ) async {
    try {
      final theaters = await remoteDataSource.getTheatersForMovie(
        movieId,
        date,
      );
      return Right(theaters);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
