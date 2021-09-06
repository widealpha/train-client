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
  );
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) {
  final val = <String, dynamic>{
    'userId': instance.userId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('gender', instance.gender);
  writeNotNull('realName', instance.realName);
  writeNotNull('headImage', instance.headImage);
  writeNotNull('nickname', instance.nickname);
  writeNotNull('phone', instance.phone);
  writeNotNull('mail', instance.mail);
  writeNotNull('address', instance.address);
  writeNotNull('selfPassengerId', instance.selfPassengerId);
  return val;
}
