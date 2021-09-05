import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train/api/api.dart';
import 'package:train/bean/coach.dart';
import 'package:train/bean/order.dart';
import 'package:train/bean/passenger.dart';
import 'package:train/bean/seat_type.dart';
import 'package:train/bean/ticket.dart';
import 'package:train/bean/train.dart';
import 'package:train/ui/change_train.dart';
import 'package:train/ui/pay_order.dart';
import 'package:train/util/date_util.dart';

class PayedOrderPage extends StatefulWidget {
  const PayedOrderPage({Key? key}) : super(key: key);

  @override
  _PayedOrderPageState createState() => _PayedOrderPageState();
}

class _PayedOrderPageState extends State<PayedOrderPage> {
  List<Order> orders = [];
  bool loading = true;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('已支付'),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    } else if (orders.isEmpty) {
      return Center(
          child: Text('还没有待支付订单哦', style: TextStyle(color: Colors.grey)));
    } else {
      return ListView.separated(
        itemBuilder: (c, i) {
          return OrderCard(
            order: orders[i],
            f: fetchData
          );
        },
        itemCount: orders.length,
        separatorBuilder: (_, __) => Divider(),
      );
    }
  }

  void fetchData() async {
    loading = true;
    setState(() {});
    List<Order> l = await OrderFormApi.allMyOrders();
    orders.clear();
    orders.addAll(l.where((o) => o.payed == 1 && (o.price ?? 0) > 0));
    loading = false;
    setState(() {});
  }
}

class OrderCard extends StatefulWidget {
  final Order order;
  final Function f;

  const OrderCard({Key? key, required this.order, required this.f})
      : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  List<Ticket> tickets = [];
  Map<Ticket, Coach> coachMap = {};
  Map<Ticket, String> seatMap = {};
  Map<String, String> seatTypeCodeToName = {};
  Map<Ticket, Passenger> passengerMap = {};

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: buildCardList(),
    );
  }

  List<Widget> buildCardList() {
    List<Widget> widgets = [];
    tickets.forEach((t) {
      widgets.add(Card(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          t.startStation!.name,
                          style: TextStyle(fontSize: 18),
                        ),
                        Padding(padding: EdgeInsets.all(2)),
                        Text(
                          t.startTime!,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.credit_card_rounded,
                                color: Colors.blue,
                              ),
                              Text('   ' + t.stationTrainCode!),
                            ],
                          ),
                          SizedBox(
                              width: 200,
                              height: 30,
                              child: Image.asset(
                                'assets/icon/right_arrow.png',
                                fit: BoxFit.fill,
                              )),
                          Text(
                            DateUtil.dateTimeInterval(t.startTime!, t.endTime!),
                          ),
                        ],
                      )),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          t.endStation!.name,
                          style: TextStyle(fontSize: 18),
                        ),
                        Padding(padding: EdgeInsets.all(2)),
                        Text(
                          t.endTime!,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    child: Text(
                        '${passengerMap[t]!.name}'
                            '  (${passengerMap[t]!.student! ? '学生' : '成人'}票)'
                            ' ${seatTypeCodeToName[coachMap[t]!.seatTypeCode]}'
                            ' ${coachMap[t]!.coachNo}车'
                            ' ${seatMap[t]}号'
                            ' ￥${t.price}                      '),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                        child: TextButton(
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.redAccent),
                            onPressed: () {
                              Get.dialog(AlertDialog(
                                title: Text('温馨提醒'),
                                content: Text('确认退订订单吗?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text('取消'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await OrderFormApi.cancelOrderForm(
                                          widget.order.orderId!);
                                      widget.f();
                                      Get.back();
                                      Get.back();
                                    },
                                    child: Text('确定'),
                                  ),
                                ],
                              ));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Text(
                                '退票',
                                style: TextStyle(fontSize: 18),
                              ),
                            ))),
                  ),
                  Expanded(
                    child: Center(
                        child: TextButton(
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.blue),
                            onPressed: () async {
                              Train? train = await Get.to(() => ChangeTrainPage(ticket: t));
                              if (train != null){
                                Get.dialog(AlertDialog(
                                  title: Text('温馨提醒'),
                                  content: Text('确认从 ${t.stationTrainCode} 改签到 ${train.stationTrainCode} 吗'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('取消'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Order? order = await TicketApi.changeTicket(t.ticketId!,train.stationTrainCode!);
                                        if (order == null){
                                          BotToast.showText(text: '改签失败');
                                        } else {
                                          if (order.price! > 0){
                                            await Get.to(() => PayOrderPage(order: order));

                                          } else {
                                            BotToast.showText(text: '改签成功');
                                          }
                                          widget.f();
                                          Get.back();
                                          Get.back();
                                        }
                                      },
                                      child: Text('确定'),
                                    ),
                                  ],
                                ));
                              }
                              widget.f();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Text(
                                '改签',
                                style: TextStyle(fontSize: 18),
                              ),
                            ))),
                  ),
                ],
              ),
            )
          ],
        ),
      ));
    });
    return widgets;
  }

  void fetchData() async {
    tickets = await TicketApi.ticketInfoByOrder(widget.order.orderId!);
    for (Ticket ticket in tickets) {
      ticket.startStation =
          StationApi.cachedStationInfo(ticket.startStationTelecode!);
      ticket.endStation =
          StationApi.cachedStationInfo(ticket.endStationTelecode!);
      coachMap[ticket] = (await CoachApi.coachInfo(ticket.coachId!))!;
      seatMap[ticket] =
      await TicketApi.transferSeatBigInteger(bigInteger: '${ticket.seat}');
      List<Passenger> passengers = await PassengerApi.allMyPassengers();
      passengers.forEach((element) {
        if (element.passengerId == ticket.passengerId){
          passengerMap[ticket] = element;
        }
      });
      List<SeatType> seatTypes = await SeatTypeApi.allSeatTypes();
      seatTypes.forEach((element) {
        seatTypeCodeToName[element.seatTypeCode!] = element.seatTypeName!;
      });
      setState(() {});
    }
    setState(() {});
  }
}