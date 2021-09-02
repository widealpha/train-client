// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeatType _$SeatTypeFromJson(Map<String, dynamic> json) {
  return SeatType(
    seatTypeCode: json['seatTypeCode'] as String?,
    seatTypeName: json['seatTypeName'] as String?,
  );
}

Map<String, dynamic> _$SeatTypeToJson(SeatType instance) => <String, dynamic>{
      'seatTypeCode': instance.seatTypeCode,
      'seatTypeName': instance.seatTypeName,
    };
