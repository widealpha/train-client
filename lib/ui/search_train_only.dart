import 'package:bot_toast/bot_toast.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train/api/api.dart';
import 'package:train/bean/train.dart';
import 'package:train/bean/train_station.dart';
import 'package:train/util/date_util.dart';

class SearchTrainOnly extends StatefulWidget {
  final String stationTrainCode;

  const SearchTrainOnly({Key? key, required this.stationTrainCode})
      : super(key: key);

  @override
  _SearchTrainOnlyState createState() => _SearchTrainOnlyState();
}

class _SearchTrainOnlyState extends State<SearchTrainOnly> {
  final ExpandableController _expandableController =
      ExpandableController(initialExpanded: true);
  Train? train;
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
        title: Text(widget.stationTrainCode),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : train == null
              ? Center(
                  child: Text(
                    '没有找到${widget.stationTrainCode}的信息',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : Card(
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
                                child: Text(
                                    getStationName(
                                        train!.startStationTelecode!),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                width: 80,
                              ),
                              Container(
                                child: Column(children: [
                                  Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Material(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: Colors.deepOrange,
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(4),
                                          child: Text(
                                            '始',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(getStationName(
                                        train!.startStationTelecode))
                                  ]),
                                  Text(train!.startStartTime!,
                                      style: TextStyle(color: Colors.blue))
                                ]),
                                width: 100,
                              ),
                              Expanded(
                                  child: Column(
                                children: [
                                  Text(
                                    DateUtil.timeInterval(
                                        train!.startStartTime!,
                                        train!.endArriveTime!),
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
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Material(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Colors.green,
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(4),
                                            child: Text(
                                              '终',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )),
                                    Text(getStationName(
                                        train!.endStationTelecode!))
                                  ]),
                                  Text(train!.endArriveTime!,
                                      style: TextStyle(color: Colors.blue))
                                ]),
                              ),
                            ],
                          )),
                      onTap: () {},
                    ),
                    expanded: buildExpand(),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                    collapsed: Container(),
                  ),
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
    List<TrainStation> trainStations = train!.trainStations!;
    for (int i = 0; i < trainStations.length; i++) {
      TrainStation t = trainStations[i];
      rows.add(TableRow(children: [
        Padding(
          padding: EdgeInsets.all(6),
          child: Text('${i + 1}'),
        ),
        Text(
          StationApi.cachedStationInfo(trainStations[i].stationTelecode)!.name,
          style: TextStyle(color: Colors.black),
        ),
        Text(
          t.arriveTime == null
              ? '---'
              : t.arriveTime +
                  '${t.updateArriveTime != null ? '(晚点:${t.updateArriveTime})' : ''}' +
                  '${t.arriveDayDiff == 0 ? '' : '  +${t.arriveDayDiff}天'}',
          style: TextStyle(color: Colors.black),
        ),
        Text(
          t.startTime == null
              ? '---'
              : t.startTime +
                  '${t.updateStartTime != null ? ' (晚点:${t.updateStartTime}) ' : ''}' +
                  '${t.startDayDiff == 0 ? '' : '  +${t.startDayDiff}天'}',
          style: TextStyle(color: Colors.black),
        ),
        Text(
          (trainStations[i].arriveTime == null ||
                  trainStations[i].startTime == null ||
                  trainStations[i].startTime == trainStations[i].arriveTime)
              ? '---'
              : DateUtil.timeInterval(
                      trainStations[i].startTime, trainStations[i].arriveTime)
                  .substring(3),
          style: TextStyle(color: Colors.black),
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

  void fetchData() async {
    loading = true;
    setState(() {});
    train = await TrainApi.trainInfo(widget.stationTrainCode);
    if (train == null || !isRunning()) {
      BotToast.showText(text: '列车数据不存在,或列车已停运');
      Get.back();
    }
    loading = false;
    setState(() {});
  }

  String getStationName(String? telecode) {
    if (telecode == null) {
      return '---';
    }
    return StationApi.cachedStationInfo(telecode)?.name ?? '---';
  }

  bool isRunning() {
    try {
      return DateTime.parse(train!.stopDate!).isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }
}
