import 'package:json_annotation/json_annotation.dart';

part 'train.g.dart';

@JsonSerializable()
class Train {
  String? trainNo;
  String? stationTrainCode;
  String? startStationTelecode;
  String? startStartTime;
  String? endStationTelecode;
  String? endArriveTime;
  String? trainTypeCode;
  String? trainClassCode;
  String? seatTypes;
  String? startDate;
  String? stopDate;

  Train({this.trainNo, this.stationTrainCode, this.startStationTelecode, this.startStartTime, this.endStationTelecode, this.endArriveTime, this.trainTypeCode, this.trainClassCode, this.seatTypes, this.startDate, this.stopDate});

  factory Train.fromJson(Map<String, dynamic> json) => _$TrainFromJson(json);

  Map<String, dynamic> toJson() => _$TrainToJson(this);
}

