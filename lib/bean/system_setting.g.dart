// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemSetting _$SystemSettingFromJson(Map<String, dynamic> json) {
  return SystemSetting(
    id: json['id'] as num,
    start: json['start'] as num,
    updateTime: json['updateTime'] as String,
    maxTransferCalculate: json['maxTransferCalculate'] as num,
  );
}

Map<String, dynamic> _$SystemSettingToJson(SystemSetting instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start': instance.start,
      'updateTime': instance.updateTime,
      'maxTransferCalculate': instance.maxTransferCalculate,
    };
