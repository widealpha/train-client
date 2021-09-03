// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Station _$StationFromJson(Map<String, dynamic> json) {
  return Station(
    name: json['name'] as String,
    telecode: json['telecode'] as String,
    en: json['en'] as String,
    abbr: json['abbr'] as String,
  );
}

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
      'name': instance.name,
      'telecode': instance.telecode,
      'en': instance.en,
      'abbr': instance.abbr,
    };
