import 'package:json_annotation/json_annotation.dart';

part 'seat_type.g.dart';

@JsonSerializable()
class SeatType {
  String? seatTypeCode;
  String? seatTypeName;

  SeatType({this.seatTypeCode, this.seatTypeName});

  factory SeatType.fromJson(Map<String, dynamic> json) => _$SeatTypeFromJson(json);

  Map<String, dynamic> toJson() => _$SeatTypeToJson(this);
}

