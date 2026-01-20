import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/theater_entity.dart';

part 'theater_model.g.dart';

@JsonSerializable()
class TheaterModel extends TheaterEntity {
  final List<ShowtimeModel> showtimesModel;

  const TheaterModel({
    required super.name,
    required super.location,
    required this.showtimesModel,
  }) : super(showtimes: showtimesModel);

  factory TheaterModel.fromJson(Map<String, dynamic> json) =>
      _$TheaterModelFromJson(json);
  Map<String, dynamic> toJson() => _$TheaterModelToJson(this);
}

@JsonSerializable()
class ShowtimeModel extends ShowtimeEntity {
  const ShowtimeModel({
    required super.time,
    required super.hall,
    required super.price,
    super.bonusPoints,
  });

  factory ShowtimeModel.fromJson(Map<String, dynamic> json) =>
      _$ShowtimeModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowtimeModelToJson(this);
}
