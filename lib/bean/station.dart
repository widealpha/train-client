import 'package:azlistview/azlistview.dart';
import 'package:json_annotation/json_annotation.dart';

part 'station.g.dart';

@JsonSerializable()
class Station extends ISuspensionBean{
  String name;
  String telecode;
  String en;
  String abbr;

  @JsonKey(ignore: true)
  String? tagIndex;
  @JsonKey(ignore: true)
  @override
  bool isShowSuspension = false;


  Station({required this.name, required this.telecode, required this.en, required this.abbr});

  factory Station.fromJson(Map<String, dynamic> json) => _$StationFromJson(json);

  Map<String, dynamic> toJson() => _$StationToJson(this);

  @override
  String getSuspensionTag() {
    if (tagIndex == null) {
      return abbr[0].toUpperCase();
    }
    return tagIndex!;
  }

  @override
  String toString() {
    return 'Station{name: $name, telecode: $telecode, en: $en, abbr: $abbr, tagIndex: $tagIndex}';
  }
}

