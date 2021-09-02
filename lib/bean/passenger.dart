import 'package:json_annotation/json_annotation.dart';

part 'passenger.g.dart';

@JsonSerializable()
class Passenger {
  num? passengerId;
  String? idCardNo;
  bool? student;
  bool? verified;
  bool? studentVerified;

  Passenger({this.passengerId, this.idCardNo, this.student, this.verified, this.studentVerified});

  factory Passenger.fromJson(Map<String, dynamic> json) => _$PassengerFromJson(json);

  Map<String, dynamic> toJson() => _$PassengerToJson(this);
}

