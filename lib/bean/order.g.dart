// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    orderId: json['orderId'] as num?,
    userId: json['userId'] as num?,
    payed: json['payed'] as num?,
    price: json['price'] as num?,
    time: json['time'] as String?,
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'orderId': instance.orderId,
      'userId': instance.userId,
      'payed': instance.payed,
      'price': instance.price,
      'time': instance.time,
    };
