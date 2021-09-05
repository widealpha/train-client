import 'package:bot_toast/bot_toast.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:train/api/api.dart';
import 'package:train/bean/remain_seat.dart';
import 'package:train/bean/station.dart';
import 'package:train/bean/ticket.dart';
import 'package:train/bean/train.dart';
import 'package:train/bean/train_price.dart';
import 'package:train/bean/train_station.dart';
import 'package:train/ui/main_page.dart';
import 'package:train/ui/order_confirm.dart';
import 'package:train/ui/station_page.dart';
import 'package:train/util/date_util.dart';

class TrainPage extends StatefulWidget {
  const TrainPage({Key? key}) : super(key: key);

  @override
  _TrainPageState createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  Ticket ticket = Ticket();
  DateTime date = DateTime.now();
  bool onlyHighWay = false;
  bool student = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.all(12),
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () async {
                        Station? station = await Get.to(() => StationPage());
                        if (station != null) {
                          setState(() {
                            ticket.startStation = station;
                          });
                        }
                      },
                      child: Text(ticket.startStation?.name ?? '请选择出发站',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 36)),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Get.dialog(AlertDialog(
                          title: Text('温馨提醒'),
                          content: Text('确认交换发到站吗?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('取消'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  Station? station = ticket.startStation;
                                  ticket.startStation = ticket.endStation;
                                  ticket.endStation = station;
                                  String? temp = ticket.startStationTelecode;
                                  ticket.startStationTelecode =
                                      ticket.endStationTelecode;
                                  ticket.endStationTelecode = temp;
                                });
                                Get.back();
                              },
                              child: Text('确定'),
                            ),
                          ],
                        ));
                      },
                      child: Icon(
                        Icons.train_rounded,
                        color: Colors.blue,
                        size: 36,
                      ),
                    )),
                    Expanded(
                      child: GestureDetector(
                          onTap: () async {
                            Station? station =
                                await Get.to(() => StationPage());
                            if (station != null) {
                              setState(() {
                                ticket.endStation = station;
                              });
                            }
                          },
                          child: Text(ticket.endStation?.name ?? '请选择终点站',
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 36))),
                    ),
                  ],
                ),
                Divider(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        child: Row(children: [
                          Text('选择日期: ',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.blue)),
                          Text(
                              '${DateUtil.date(date)} (${DateUtil.weekday(date)})',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18)),
                        ]),
                        onTap: () async {
                          DateTime? time = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 10)));
                          if (time != null) {
                            setState(() {
                              date = time;
                            });
                          }
                        },
                      ),
                      Container(width: 150),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('只看高铁/动车',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.blue)),
                            Checkbox(
                                value: onlyHighWay,
                                onChanged: (b) {
                                  setState(() {
                                    onlyHighWay = b ?? false;
                                  });
                                }),
                          ]),
                      Container(width: 150),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Text('学生票',
                            style: TextStyle(fontSize: 14, color: Colors.blue)),
                        Checkbox(
                            value: student,
                            onChanged: (b) {
                              setState(() {
                                student = b ?? false;
                              });
                            })
                      ])
                    ],
                  ),
                ),
                Divider(),
                Center(
                    child: TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          if (ticket.startStation == null ||
                              ticket.endStation == null) {
                            BotToast.showText(text: '出发站/终点站不能为空');
                          } else if (ticket.startStation!.telecode ==
                              ticket.endStation!.telecode) {
                            BotToast.showText(text: '出发站/终点站不能相同');
                          } else {
                            ticket.startStationTelecode =
                                ticket.startStation!.telecode;
                            ticket.endStationTelecode =
                                ticket.endStation!.telecode;
                            Get.to(() => (TrainSearchResultPage(
                                  ticket: ticket,
                                  date: date,
                                  onlyHighWay: onlyHighWay,
                                  student: student,
                                )));
                          }
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text(
                            '查询车票',
                            style: TextStyle(fontSize: 18),
                          ),
                        ))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TrainSearchResultPage extends StatefulWidget {
  final Ticket ticket;
  final DateTime date;
  final bool onlyHighWay;
  final bool student;

  const TrainSearchResultPage(
      {Key? key,
      required this.ticket,
      required this.date,
      required this.onlyHighWay,
      required this.student})
      : super(key: key);

  @override
  _TrainSearchResultPageState createState() => _TrainSearchResultPageState();
}

class _TrainSearchResultPageState extends State<TrainSearchResultPage> {
  final RefreshController _controller = RefreshController();
  bool _loading = true;
  late Ticket _ticket = widget.ticket;
  late DateTime _date = widget.date;
  late bool _canBeforeDay;
  late bool _canAfterDay;
  List<Train> trains = [];
  List<Train> filteredTrains = [];

  @override
  void initState() {
    super.initState();
    changeDate(_date);
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
            onTap: () {
              Get.dialog(AlertDialog(
                title: Text('温馨提醒'),
                content: Text('确认交换发到站吗?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('取消'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        Station? station = _ticket.startStation;
                        _ticket.startStation = _ticket.endStation;
                        _ticket.endStation = station;

                        String? temp = _ticket.startStationTelecode;
                        _ticket.startStationTelecode =
                            _ticket.endStationTelecode;
                        _ticket.endStationTelecode = temp;
                      });
                      Get.back();
                      fetchData();
                    },
                    child: Text('确定'),
                  ),
                ],
              ));
            },
            child: Text(
                '${_ticket.startStation!.name}<>${_ticket.endStation!.name}')),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: Container(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: TextButton(
                    onPressed: _canBeforeDay
                        ? () {
                            changeDate(_date.subtract(Duration(days: 1)));
                            fetchData();
                          }
                        : null,
                    child: Text(
                      '前一天',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
                  Expanded(
                      child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () async {
                      DateTime? time = await showDatePicker(
                          context: context,
                          initialDate: _date.isAfter(DateTime.now())
                              ? _date
                              : DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 10)));
                      if (time != null) {
                        setState(() {
                          changeDate(time);
                          fetchData();
                        });
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                              '${DateUtil.date(_date)} (${DateUtil.weekday(_date)})',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  )),
                  Expanded(
                      child: TextButton(
                    onPressed: _canAfterDay
                        ? () {
                            changeDate(_date.add(Duration(days: 1)));
                            fetchData();
                          }
                        : null,
                    child: Text(
                      '后一天',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
                ],
              ),
            )),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchData();
            },
          )
        ],
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    } else if (trains.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text.rich(
              TextSpan(children: [
                TextSpan(text: '很抱歉没有找到从 '),
                TextSpan(
                    text: _ticket.startStation!.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' 到 '),
                TextSpan(
                    text: _ticket.endStation!.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' 的直达列车\n'),
              ]),
              style: TextStyle(fontSize: 18),
            ),
            TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Get.toEnd(() => MainPage());
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text('接续换乘',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                )),
            Padding(padding: EdgeInsets.all(12)),
          ],
        ),
      );
    } else {
      return SmartRefresher(
          controller: _controller,
          child: ListView.builder(
            itemBuilder: (c, i) {
              return ListTile(
                title: TrainCard(
                    train: filteredTrains[i], ticket: _ticket, date: _date),
              );
            },
            itemCount: filteredTrains.length,
          ));
    }
  }

  void changeDate(DateTime date) {
    DateTime now =
        DateTime.parse(DateTime.now().toIso8601String().substring(0, 10));
    _date = DateTime.parse(_date.toIso8601String().substring(0, 10));
    date = DateTime.parse(date.toIso8601String().substring(0, 10));
    _date = date;
    _canBeforeDay = _date.isAfter(now);
    _canAfterDay = _date.isBefore(now.add(Duration(days: 10)));
    setState(() {});
  }

  List<Train> filter(List<Train> trains) {
    return trains;
  }

  Future<void> fetchData() async {
    _loading = true;
    setState(() {});
    TrainApi.trainsBetween(
            _ticket.startStationTelecode!, _ticket.endStationTelecode!)
        .then((list) {
      setState(() {
        trains = list;
        _loading = false;
        filteredTrains = filter(trains);
      });
    });
    setState(() {});
  }
}

class TrainCard extends StatefulWidget {
  final Ticket ticket;
  final Train train;
  final DateTime date;

  const TrainCard(
      {Key? key, required this.train, required this.ticket, required this.date})
      : super(key: key);

  @override
  _TrainCardState createState() => _TrainCardState();
}

class _TrainCardState extends State<TrainCard> {
  late final Train train = widget.train;
  late final Ticket ticket = widget.ticket;
  final ExpandableController _expandableController = ExpandableController();
  List<TrainPrice> trainPriceList = [];
  List<RemainSeat> remainSeatList = [];
  bool seePrice = true;

  @override
  void initState() {
    TrainApi.trainPrice(ticket.startStationTelecode!,
            ticket.endStationTelecode!, train.stationTrainCode!)
        .then((list) {
      trainPriceList.clear();
      trainPriceList.addAll(list);
      if (mounted) {
        setState(() {});
      }
    });
    TrainApi.trainTicketRemaining(
            ticket.startStationTelecode!,
            ticket.endStationTelecode!,
            train.stationTrainCode!,
            widget.date.toIso8601String().substring(0, 10))
        .then((list) {
      remainSeatList.clear();
      remainSeatList.addAll(list);
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpandablePanel(
        controller: _expandableController,
        theme: const ExpandableThemeData(
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            useInkWell: false,
            tapBodyToCollapse: true,
            tapHeaderToExpand: false),
        header: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(train.stationTrainCode!,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    width: 80,
                  ),
                  Container(
                    child: Column(children: [
                      Row(children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: stationTextWidget(ticket.startStationTelecode!,
                              train.trainStations!),
                        ),
                        Text(getStationName(ticket.startStationTelecode))
                      ]),
                      Text(getTrainStartTime(train),
                          style: TextStyle(color: Colors.blue))
                    ]),
                    width: 100,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        DateUtil.timeInterval(getTrainStartTime(train),
                            getTrainArriveTime(train)),
                        style: TextStyle(color: Colors.black45),
                      ),
                      Icon(Icons.arrow_right_alt_rounded,
                          color: Colors.blueAccent)
                    ],
                  )),
                  Container(
                    width: 100,
                    child: Column(children: [
                      Row(children: [
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: stationTextWidget(ticket.endStationTelecode!,
                                train.trainStations!)),
                        Text(getStationName(ticket.endStationTelecode!))
                      ]),
                      Text(getTrainArriveTime(train),
                          style: TextStyle(color: Colors.blue))
                    ]),
                  ),
                ],
              )),
          onTap: () {
            Get.showOverlay(
                asyncFunction: () async {
                  List<RemainSeat> l1 = await TrainApi.trainTicketRemaining(
                      ticket.startStationTelecode!,
                      ticket.endStationTelecode!,
                      train.stationTrainCode!,
                      widget.date.toIso8601String().substring(0, 10));
                  List<TrainPrice> l2 = await TrainApi.trainPrice(
                      ticket.startStationTelecode!,
                      ticket.endStationTelecode!,
                      train.stationTrainCode!);
                  Get.to(() => OrderConfirmPage(
                        remainSeatList: l1,
                        trainPriceList: l2,
                        date: widget.date,
                        ticket: ticket,
                        train: train,
                      ));
                },
                loadingWidget: Dialog(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: Text(
                      '正在生成订单,请稍后...',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ));
          },
        ),
        collapsed: buildCollapsed(),
        expanded: buildExpand(),
        builder: (_, collapsed, expanded) {
          return Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Expandable(
              collapsed: collapsed,
              expanded: expanded,
              theme: const ExpandableThemeData(crossFadePoint: 0),
            ),
          );
        },
      ),
    );
  }

  Widget buildExpand() {
    List<TableRow> rows = [];
    rows.add(
        TableRow(decoration: BoxDecoration(color: Colors.grey[100]), children: [
      Padding(
          padding: EdgeInsets.all(6),
          child: Text('站序号', style: TextStyle(color: Colors.blueAccent))),
      Text('站名', style: TextStyle(color: Colors.blueAccent)),
      Text('到时', style: TextStyle(color: Colors.blueAccent)),
      Text('发时', style: TextStyle(color: Colors.blueAccent)),
      Text('时长', style: TextStyle(color: Colors.blueAccent)),
    ]));
    List<TrainStation> trainStations = train.trainStations!;
    for (int i = 0; i < trainStations.length; i++) {
      rows.add(TableRow(children: [
        Padding(
          padding: EdgeInsets.all(6),
          child: Text('${i + 1}'),
        ),
        Text(
          StationApi.cachedStationInfo(trainStations[i].stationTelecode)!.name,
          style: TextStyle(
              color: (trainStations[i].stationTelecode ==
                          ticket.startStationTelecode ||
                      trainStations[i].stationTelecode ==
                          ticket.endStationTelecode)
                  ? Colors.blueAccent
                  : Colors.black),
        ),
        Text(
          trainStations[i].arriveTime ?? '---',
          style: TextStyle(
              color: (trainStations[i].stationTelecode ==
                          ticket.startStationTelecode ||
                      trainStations[i].stationTelecode ==
                          ticket.endStationTelecode)
                  ? Colors.blueAccent
                  : Colors.black),
        ),
        Text(
          trainStations[i].startTime ?? '---',
          style: TextStyle(
              color: (trainStations[i].stationTelecode ==
                          ticket.startStationTelecode ||
                      trainStations[i].stationTelecode ==
                          ticket.endStationTelecode)
                  ? Colors.blueAccent
                  : Colors.black),
        ),
        Text(
          (trainStations[i].arriveTime == null ||
                  trainStations[i].startTime == null ||
                  trainStations[i].startTime == trainStations[i].arriveTime)
              ? '---'
              : DateUtil.timeInterval(
                      trainStations[i].startTime, trainStations[i].arriveTime)
                  .substring(3),
          style: TextStyle(
              color: (trainStations[i].stationTelecode ==
                          ticket.startStationTelecode ||
                      trainStations[i].stationTelecode ==
                          ticket.endStationTelecode)
                  ? Colors.blueAccent
                  : Colors.black),
        ),
      ]));
    }
    return Table(
      border: TableBorder(
          horizontalInside: BorderSide(color: Colors.grey, width: 0.2)),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: rows,
    );
  }

  Widget buildCollapsed() {
    if (seePrice) {
      return Column(
        children: [
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: trainPriceList
                .map((e) => Expanded(
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(text: '${e.seatTypeName}:  '),
                          TextSpan(
                              text: '￥${e.price}',
                              style: TextStyle(color: Colors.green))
                        ]),
                        textAlign: TextAlign.center,
                      ),
                    ))
                .toList(),
          )
        ],
      );
    } else {
      return Column(
        children: [
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: remainSeatList
                .map((e) => Expanded(
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                              text: '${e.seatTypeName}:  ',
                              style: TextStyle(
                                  color: e.remaining == 0
                                      ? Colors.grey
                                      : Colors.black)),
                          TextSpan(
                              text: e.remaining == 0 ? '无' : '${e.remaining}张',
                              style: TextStyle(
                                  color: e.remaining == 0
                                      ? Colors.grey
                                      : Colors.green))
                        ]),
                        textAlign: TextAlign.center,
                      ),
                    ))
                .toList(),
          ),
        ],
      );
    }
  }

  Widget stationTextWidget(
      String stationTelecode, List<TrainStation> stations) {
    String s = '过';
    if (stationTelecode == stations.first.stationTelecode) {
      s = '始';
    } else if (stationTelecode == stations.last.stationTelecode) {
      s = '终';
    }

    return Material(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      color: s == '过'
          ? Colors.blue
          : s == '始'
              ? Colors.deepOrange
              : Colors.green,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(4),
        child: Text(
          s,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
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
