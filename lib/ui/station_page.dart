import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:train/api/api.dart';
import 'package:train/bean/station.dart';

class StationPage extends StatefulWidget {
  const StationPage({Key? key}) : super(key: key);

  @override
  _StationPageState createState() => _StationPageState();
}

class _StationPageState extends State<StationPage> {
  List<Station> suggestions = [];
  List<Station> stationList = [];
  Map<String, Station> stations = {};
  Map<String, List<Station>> alphabetMap = {};
  double susItemHeight = 36;

  @override
  void initState() {
    super.initState();
    stationList = [];
    stations = {};
    alphabetMap = {};
    StationApi.allStations().then((List<Station> list) {
      stationList = List.from(list);
      list.forEach((Station s) {
        stations[s.en] = s;
        if (alphabetMap.containsKey(s.abbr[0])) {
          alphabetMap[s.abbr[0]]?.add(s);
        } else {
          alphabetMap[s.abbr[0]] = [s];
        }
      });
      stationList.sort((a, b) {
        return (a.abbr.compareTo(b.abbr));
      });
      // SuspensionUtil.sortListBySuspensionTag(stationList);
      stationList.insert(
          0,
          Station(name: 'name', telecode: '', en: '', abbr: '')
            ..tagIndex = '★');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          stationList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Container(
                      color: Colors.white,
                      height: 56.0,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: TextField(
                            autofocus: false,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 10, right: 10),
                                border: InputBorder.none,
                                labelStyle: TextStyle(
                                    fontSize: 14, color: Color(0xFF333333)),
                                hintText: '城市中文名或拼音',
                                hintStyle: TextStyle(
                                    fontSize: 14, color: Color(0xFFCCCCCC))),
                          )),
                          Container(
                            width: 0.33,
                            height: 14.0,
                            color: Color(0xFFEFEFEF),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "取消",
                                style: TextStyle(
                                    color: Color(0xFF999999), fontSize: 14),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: .0,
                    ),
                    Expanded(
                      child: AzListView(
                        padding: EdgeInsets.only(left: 24),
                        data: stationList,
                        itemCount: stationList.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) return _buildHeader();
                          Station model = stationList[index];
                          return ListTile(
                              title: Text(model.name),
                              onTap: () {
                                Get.back(result: model);
                              });
                        },
                        susItemHeight: susItemHeight,
                        susItemBuilder: (BuildContext context, int index) {
                          Station model = stationList[index];
                          String tag = model.getSuspensionTag();
                          if ('★' == tag) {
                            return Container();
                          }
                          return Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 40.0),
                            color: Color(0xFFF3F4F5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '$tag',
                              softWrap: false,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF666666),
                              ),
                            ),
                          );
                        },
                        indexBarAlignment: Alignment.centerLeft,
                        indexBarData:
                            SuspensionUtil.getTagIndexList(stationList),
                        indexBarOptions: IndexBarOptions(
                          needRebuild: true,
                          color: Colors.transparent,
                          downColor: Color(0xFFEEEEEE),
                        ),
                      ),
                    ),
                  ],
                ),
          buildFloatingSearchBar(),
        ],
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      hint: '搜索拼音或城市',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      // width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        suggestions.clear();
        stationList.forEach((s) {
          if (s.name == 'name') {
            return;
          }
          if (s.abbr.contains(query) ||
              s.name.contains(query) ||
              s.en.contains(query)) {
            suggestions.add(s);
          }
        });
        setState(() {});
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {
              Get.back(result: stations['jinanxi']);
            },
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: suggestions
                  .map(
                    (e) => ListTile(
                      title: Text(e.name),
                      onTap: () {
                        Get.back(result: e);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    List<Station> hotCityList = [];
    hotCityList.addAll([
      Station.fromJson(stations['xuzhoudong']!.toJson())..tagIndex = '★',
      Station.fromJson(stations['jinanxi']!.toJson())..tagIndex = '★',
      Station.fromJson(stations['beijingnan']!.toJson())..tagIndex = '★',
      Station.fromJson(stations['beijing']!.toJson())..tagIndex = '★',
      Station.fromJson(stations['shanghai']!.toJson())..tagIndex = '★',
    ]);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: 10.0,
        children: hotCityList.map((e) {
          return OutlinedButton(
            style: ButtonStyle(
                //side: BorderSide(color: Colors.grey[300], width: .5),
                ),
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(e.name),
            ),
            onPressed: () {
              Get.back(result: e..tagIndex = null);
            },
          );
        }).toList(),
      ),
    );
  }
}
