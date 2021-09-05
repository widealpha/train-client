import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:train/api/api.dart';
import 'package:train/bean/coach.dart';
import 'package:train/bean/order.dart';
import 'package:train/bean/ticket.dart';
import 'package:train/bean/train.dart';
import 'package:train/bean/train_station.dart';
import 'package:train/util/date_util.dart';

class PayOrderPage extends StatefulWidget {
  final Order order;

  const PayOrderPage({Key? key, required this.order}) : super(key: key);

  @override
  _PayOrderPageState createState() => _PayOrderPageState();
}

class _PayOrderPageState extends State<PayOrderPage> {
  List<Ticket> tickets = [];
  Map<Ticket, Coach> coachMap = {};
  Map<Ticket, String> seatMap = {};
  DateTime time = DateTime.now();
  Timer? _timer;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
          setState(() {
            time = time.add(oneSec);
          })
        };

    _timer = Timer.periodic(oneSec, callback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.order.payed == 0
            ? '未支付'
            : widget.order.payed == 1
                ? '已支付'
                : '已取消'),
        bottom: PreferredSize(
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        child: widget.order.payed == 0
                            ? Icon(
                                Icons.lock_clock_rounded,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.done_rounded,
                                color: Colors.white,
                              ),
                      ),
                      Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            widget.order.payed == 0
                                ? '未支付'
                                : widget.order.payed == 1
                                    ? '已支付'
                                    : '已取消',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      child: Text(
                        '剩余时间:   ${freeTime()}',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
            preferredSize: Size.fromHeight(40)),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                    child: ListView.separated(
                  itemBuilder: (c, i) {
                    Ticket ticket = tickets[i];
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      ticket.startStation!.name,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Padding(padding: EdgeInsets.all(2)),
                                    Text(
                                      ticket.startTime!,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.credit_card_rounded,
                                        color: Colors.blue,
                                      ),
                                      Text('   ' + ticket.stationTrainCode!),
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
                                    DateUtil.dateTimeInterval(
                                        ticket.startTime!, ticket.endTime!),
                                  ),
                                ],
                              )),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      ticket.endStation!.name,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Padding(padding: EdgeInsets.all(2)),
                                    Text(
                                      ticket.endTime!,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: tickets.length,
                  separatorBuilder: (_, __) => Divider(),
                )),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.blue),
                              onPressed: () async {
                                String? s = await OrderFormApi.payOrderForm(
                                    widget.order.orderId!);
                                if (s != null) {
                                  Get.showOverlay(
                                      asyncFunction: () async {
                                        while (true) {
                                          if (await OrderFormApi
                                                  .orderFormStatus(
                                                      widget.order.orderId!) ==
                                              1) {
                                            BotToast.showText(text: '支付成功');
                                            Get.back();
                                            Get.back();
                                            break;
                                          }
                                        }
                                      },
                                      loadingWidget: Dialog(
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          alignment: Alignment.center,
                                          child: QrImage(data: s),
                                        ),
                                      ));
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Text(
                                  '支付订单 共:￥${widget.order.price}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              )))
                    ],
                  ),
                )
              ],
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  String freeTime() {
    Duration duration = time.difference(DateTime.parse(widget.order.time!));
    Duration tMinutes = Duration(minutes: 30);
    if (tMinutes.inSeconds < duration.inSeconds) {
      return '订单已超时';
    }
    return '${tMinutes.inMinutes - duration.inMinutes}分钟${(tMinutes.inSeconds - duration.inSeconds) % 60}秒';
  }

  void fetchData() async {
    setState(() {
      loading = true;
    });
    tickets = await TicketApi.ticketInfoByOrder(widget.order.orderId!);
    for (Ticket ticket in tickets) {
      ticket.startStation =
          StationApi.cachedStationInfo(ticket.startStationTelecode!);
      ticket.endStation =
          StationApi.cachedStationInfo(ticket.endStationTelecode!);
      coachMap[ticket] = (await CoachApi.coachInfo(ticket.coachId!))!;
      seatMap[ticket] =
          await TicketApi.transferSeatBigInteger(bigInteger: ticket.seat);
    }
    setState(() {
      loading = false;
    });
  }

  String getStationName(String? telecode) {
    if (telecode == null) {
      return '---';
    }
    return StationApi.cachedStationInfo(telecode)?.name ?? '---';
  }

  String getTrainStartTime(Train train) {
    if (train.trainStations == null) {
      return '---';
    }
    for (TrainStation station in train.trainStations!) {
      if (station.stationTelecode == train.nowStartStationTelecode) {
        return station.startTime;
      }
    }
    return '---';
  }

  String getTrainArriveTime(Train train) {
    if (train.trainStations == null) {
      return '---';
    }
    for (TrainStation station in train.trainStations!) {
      if (station.stationTelecode == train.nowEndStationTelecode) {
        return station.arriveTime;
      }
    }
    return '---';
  }
}

class NeedToPayPage extends StatefulWidget {
  const NeedToPayPage({Key? key}) : super(key: key);

  @override
  _NeedToPayPageState createState() => _NeedToPayPageState();
}

class _NeedToPayPageState extends State<NeedToPayPage> {
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
        title: Text('未完成'),
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
            f: fetchData,
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
    orders.addAll(l.where((o) => o.payed == 0));
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
                                '退订订单',
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
                            onPressed: () {
                              Get.to(() => PayOrderPage(order: widget.order));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Text(
                                '支付订单',
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
          await TicketApi.transferSeatBigInteger(bigInteger: ticket.seat);
      setState(() {});
    }
    setState(() {});
  }
}
