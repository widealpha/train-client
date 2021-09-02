import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
  int? userId;
  int? gender;
  String? realName;
  String? headImage;
  String? nickname;
  String? phone;
  String? mail;
  String? address;
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
