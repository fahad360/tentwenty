// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theater_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TheaterModel _$TheaterModelFromJson(Map<String, dynamic> json) => TheaterModel(
  name: json['name'] as String,
  location: json['location'] as String,
  showtimesModel: (json['showtimesModel'] as List<dynamic>)
      .map((e) => ShowtimeModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TheaterModelToJson(TheaterModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'location': instance.location,
      'showtimesModel': instance.showtimesModel,
    };

ShowtimeModel _$ShowtimeModelFromJson(Map<String, dynamic> json) =>
    ShowtimeModel(
      time: json['time'] as String,
      hall: json['hall'] as String,
      price: (json['price'] as num).toInt(),
      bonusPoints: (json['bonusPoints'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ShowtimeModelToJson(ShowtimeModel instance) =>
    <String, dynamic>{
      'time': instance.time,
      'hall': instance.hall,
      'price': instance.price,
      'bonusPoints': instance.bonusPoints,
    };
