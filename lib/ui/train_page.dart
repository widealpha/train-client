import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train/bean/station.dart';
import 'package:train/bean/ticket.dart';
import 'package:train/ui/search_train_only.dart';
import 'package:train/ui/station_page.dart';
import 'package:train/ui/train_search_result.dart';
import 'package:train/util/date_util.dart';

bool seePrice = true;

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
  TextEditingController _controller = TextEditingController();

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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: Get.width,
            child: Card(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '请输入列车号搜索列车',
                    suffixIcon: TextButton.icon(
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          Get.to(
                                () => SearchTrainOnly(
                                stationTrainCode: _controller.text),
                          );
                        }
                      },
                      icon: Icon(Icons.search_rounded),
                      label: Text('搜索列车'),
                    )),
              ),
            ),
          ),
        )
      ],
    );
  }
}
