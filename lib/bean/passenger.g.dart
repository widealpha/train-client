// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Passenger _$PassengerFromJson(Map<String, dynamic> json) {
  return Passenger(
    passengerId: json['passengerId'] as num?,
    idCardNo: json['idCardNo'] as String?,
    student: json['student'] as bool?,
    verified: json['verified'] as bool?,
    studentVerified: json['studentVerified'] as bool?,
  );
}

Map<String, dynamic> _$PassengerToJson(Passenger instance) => <String, dynamic>{
      'passengerId': instance.passengerId,
      'idCardNo': instance.idCardNo,
      'student': instance.student,
      'verified': instance.verified,
      'studentVerified': instance.studentVerified,
    };
