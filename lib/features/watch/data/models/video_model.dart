import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/video_entity.dart';

part 'video_model.g.dart';

@JsonSerializable()
class VideoModel extends VideoEntity {
  const VideoModel({
    required super.key,
    required super.name,
    required super.site,
    required super.type,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoModelFromJson(json);

  Map<String, dynamic> toJson() => _$VideoModelToJson(this);
}

@JsonSerializable(createToJson: false)
class VideoResponse {
  final List<VideoModel> results;

  VideoResponse({required this.results});

  factory VideoResponse.fromJson(Map<String, dynamic> json) =>
      _$VideoResponseFromJson(json);
}
