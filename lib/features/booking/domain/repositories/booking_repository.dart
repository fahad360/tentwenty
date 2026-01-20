import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_model.dart';
import '../entities/theater_entity.dart';

abstract class BookingRepository {
  Future<Either<Failure, List<TheaterEntity>>> getTheatersForMovie(
    int movieId,
    String date,
  );
}
