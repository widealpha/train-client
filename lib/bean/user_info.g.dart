// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(
    userId: json['userId'] as int?,
    gender: json['gender'] as int?,
    realName: json['realName'] as String?,
    headImage: json['headImage'] as String?,
    nickname: json['nickname'] as String?,
    phone: json['phone'] as String?,
    mail: json['mail'] as String?,
    address: json['address'] as String?,
    selfPassengerId: json['selfPassengerId'] as int?,
  )..idCardNo = json['idCardNo'] as String?;
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'userId': instance.userId,
      'gender': instance.gender,
      'realName': instance.realName,
      'headImage': instance.headImage,
      'nickname': instance.nickname,
      'phone': instance.phone,
      'mail': instance.mail,
      'address': instance.address,
      'selfPassengerId': instance.selfPassengerId,
      'idCardNo': instance.idCardNo,
    };
