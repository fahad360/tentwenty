import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  final String key;
  final String name;
  final String site;
  final String type;

  const VideoEntity({
    required this.key,
    required this.name,
    required this.site,
    required this.type,
  });

  @override
  List<Object?> get props => [key, name, site, type];
}
