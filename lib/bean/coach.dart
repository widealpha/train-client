import 'package:json_annotation/json_annotation.dart';

part 'coach.g.dart';

@JsonSerializable()
class Coach {
  num coachId;
  num coachNo;
  String stationTrainCode;
  String seatTypeCode;
  num seat;

  Coach({required this.coachId, required this.coachNo, required this.stationTrainCode, required this.seatTypeCode, required this.seat});

  factory Coach.fromJson(Map<String, dynamic> json) => _$CoachFromJson(json);

  Map<String, dynamic> toJson() => _$CoachToJson(this);
}

