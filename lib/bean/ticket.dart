import 'package:json_annotation/json_annotation.dart';

part 'ticket.g.dart';

@JsonSerializable()
class Ticket {
  num? ticketId;
  num? coachId;
  String? stationTrainCode;
  String? startStationTelecode;
  String? endStationTelecode;
  String? startTime;
  String? endTime;
  num? price;
  num? passengerId;
  num? orderId;
  bool? student;

  Ticket({this.ticketId, this.coachId, this.stationTrainCode, this.startStationTelecode, this.endStationTelecode, this.startTime, this.endTime, this.price, this.passengerId, this.orderId, this.student});

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

  Map<String, dynamic> toJson() => _$TicketToJson(this);
}

