import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
  int? userId;
  @JsonKey(includeIfNull: false)
  int? gender;
  @JsonKey(includeIfNull: false)
  String? realName;
  @JsonKey(includeIfNull: false)
  String? headImage;
  @JsonKey(includeIfNull: false)
  String? nickname;
  @JsonKey(includeIfNull: false)
  String? phone;
  @JsonKey(includeIfNull: false)
  String? mail;
  @JsonKey(includeIfNull: false)
  String? address;
  @JsonKey(includeIfNull: false)
  int? selfPassengerId;



  UserInfo(
      {this.userId,
      this.gender,
      this.realName,
      this.headImage,
      this.nickname,
      this.phone,
      this.mail,
      this.address,
      this.selfPassengerId});

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson(instance) => _$UserInfoToJson(this);
}
