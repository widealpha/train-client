import 'package:json_annotation/json_annotation.dart';

part 'passenger.g.dart';

@JsonSerializable()
class Passenger {
  num? passengerId;
  String? idCardNo;
  bool? student;
  bool? verified;
  bool? studentVerified;
  String? name;
  String? phone;


  Passenger(
      {this.passengerId,
      this.idCardNo,
      this.student,
      this.verified,
      this.studentVerified,
      this.name,
      this.phone});

  factory Passenger.fromJson(Map<String, dynamic> json) => _$PassengerFromJson(json);

  Map<String, dynamic> toJson() => _$PassengerToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Passenger &&
          runtimeType == other.runtimeType &&
          passengerId == other.passengerId &&
          idCardNo == other.idCardNo &&
          student == other.student &&
          verified == other.verified &&
          studentVerified == other.studentVerified &&
          name == other.name &&
          phone == other.phone;

  @override
  int get hashCode =>
      passengerId.hashCode ^
      idCardNo.hashCode ^
      student.hashCode ^
      verified.hashCode ^
      studentVerified.hashCode ^
      name.hashCode ^
      phone.hashCode;
}

