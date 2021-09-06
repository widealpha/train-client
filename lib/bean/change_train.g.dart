// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_train.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeTrain _$ChangeTrainFromJson(Map<String, dynamic> json) {
  return ChangeTrain(
    firstStationTrainCode: json['firstStationTrainCode'] as String,
    firstTrainArriveTime: json['firstTrainArriveTime'] as String,
    lastStationTrainCode: json['lastStationTrainCode'] as String,
    lastTrainStartTime: json['lastTrainStartTime'] as String,
    changeStation: json['changeStation'] as String,
    interval: json['interval'] as num,
    firstTrain: Train.fromJson(json['firstTrain'] as Map<String, dynamic>),
    lastTrain: Train.fromJson(json['lastTrain'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ChangeTrainToJson(ChangeTrain instance) =>
    <String, dynamic>{
      'firstStationTrainCode': instance.firstStationTrainCode,
      'firstTrainArriveTime': instance.firstTrainArriveTime,
      'lastStationTrainCode': instance.lastStationTrainCode,
      'lastTrainStartTime': instance.lastTrainStartTime,
      'changeStation': instance.changeStation,
      'firstTrain': instance.firstTrain,
      'lastTrain': instance.lastTrain,
      'interval': instance.interval,
    };
