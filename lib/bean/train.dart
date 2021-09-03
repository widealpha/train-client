import 'package:json_annotation/json_annotation.dart';
import 'package:train/bean/seat_type.dart';
import 'package:train/bean/station.dart';
import 'package:train/bean/train_class.dart';

part 'train.g.dart';

@JsonSerializable()
class Train {
  String? trainNo;
  String? stationTrainCode;
  String? startStationTelecode;
  Station? startStation;
  String? startStartTime;
  String? endStationTelecode;
  Station? endStation;
  String? endArriveTime;
  String? trainTypeCode;
  String? trainClassCode;
  TrainClass? tranClass;
  String? seatTypes;
  SeatType? seatType;
  String? startDate;
  String? stopDate;

  Train(
      {this.trainNo,
      this.stationTrainCode,
      this.startStationTelecode,
      this.startStartTime,
      this.endStationTelecode,
      this.endArriveTime,
      this.trainTypeCode,
      this.trainClassCode,
      this.seatTypes,
      this.startDate,
      this.stopDate});

  factory Train.fromJson(Map<String, dynamic> json) => _$TrainFromJson(json);

  Map<String, dynamic> toJson() => _$TrainToJson(this);
}
