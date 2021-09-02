import 'package:json_annotation/json_annotation.dart';

part 'station.g.dart';

@JsonSerializable()
class Station {
  String? name;
  String? telecode;
  String? en;
  String? abbr;

  Station({this.name, this.telecode, this.en, this.abbr});

  factory Station.fromJson(Map<String, dynamic> json) => _$StationFromJson(json);

  Map<String, dynamic> toJson() => _$StationToJson(this);
}

