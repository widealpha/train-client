import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  num? orderId;
  num? userId;
  num? payed;
  num? price;
  String? time;

  Order({this.orderId, this.userId, this.payed, this.price, this.time});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

