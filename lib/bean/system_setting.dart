import 'package:json_annotation/json_annotation.dart';

part 'system_setting.g.dart';

@JsonSerializable()
class SystemSetting {
  num id;
  num start;
  String updateTime;
  num maxTransferCalculate;

  SystemSetting({required this.id, required this.start, required this.updateTime, required this.maxTransferCalculate});

  factory SystemSetting.fromJson(Map<String, dynamic> json) => _$SystemSettingFromJson(json);

  Map<String, dynamic> toJson() => _$SystemSettingToJson(this);
}

