import 'package:json_annotation/json_annotation.dart';

part 'change_train.g.dart';

@JsonSerializable()
class ChangeTrain {
  String firstStationTrainCode;
  String firstTrainArriveTime;
  String lastStationTrainCode;
  String lastTrainStartTime;
  String changeStation;
  num interval;

  ChangeTrain({required this.firstStationTrainCode, required this.firstTrainArriveTime, required this.lastStationTrainCode, required this.lastTrainStartTime, required this.changeStation, required this.interval});

  factory ChangeTrain.fromJson(Map<String, dynamic> json) => _$ChangeTrainFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeTrainToJson(this);
}

