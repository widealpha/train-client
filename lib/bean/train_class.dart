import 'package:json_annotation/json_annotation.dart';

part 'train_class.g.dart';

@JsonSerializable()
class TrainClass {
  String? trainClassCode;
  String? trainClassName;

  TrainClass({this.trainClassCode, this.trainClassName});

  factory TrainClass.fromJson(Map<String, dynamic> json) => _$TrainClassFromJson(json);

  Map<String, dynamic> toJson() => _$TrainClassToJson(this);
}

