import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train/api/api.dart';
import 'package:train/bean/passenger.dart';
import 'package:train/ui/add_passenger.dart';

class ChoosePassengerPage extends StatefulWidget {
  final List<Passenger> choose;

  const ChoosePassengerPage({Key? key, required this.choose}) : super(key: key);

  @override
  _ChoosePassengerPageState createState() => _ChoosePassengerPageState();
}

class _ChoosePassengerPageState extends State<ChoosePassengerPage> {
  Map<Passenger, bool> allPassengers = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择乘车人'),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                Get.back(
                    result: allPassengers.keys
                        .where((p) => allPassengers[p]!)
                        .toList());
              },
              child: Text(
                '完成',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            alignment: Alignment.center,
            child: GestureDetector(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline_rounded, color: Colors.blue),
                  Text('  添加乘车人')
                ],
              ),
              onTap: () async {
                Passenger? passenger = await Get.to(() => AddPassengerPage());
                if (passenger != null) {
                  allPassengers[passenger] = false;
                }
                setState(() {});
              },
            ),
          ),
          Divider(
            thickness: 2,
          ),
          loading
              ? Center(child: CircularProgressIndicator())
              : allPassengers.keys.isEmpty
                  ? Center(
                      child: Text(
                      '暂无乘车人',
                      style: TextStyle(color: Colors.grey),
                    ))
                  : Column(
                      children: allPassengers.keys
                          .map((p) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Text(p.name!, textAlign: TextAlign.center)),
                                Expanded(
                                  flex:2,
                                  child:
                                  Text(p.idCardNo!.replaceRange(5, 16, '*' * 11), textAlign: TextAlign.center),
                                ),
                                Expanded(
                                  child: Text(p.student ?? false ? '学生' : '成人',
                                      style: TextStyle(color: Colors.blue)),
                                ),
                                Expanded(
                                    child: Checkbox(
                                      value: allPassengers[p],
                                      onChanged: (b) {
                                        setState(() {
                                          allPassengers[p] = b ?? false;
                                        });
                                      },
                                    )),
                              ],
                            ),
                            Divider()
                          ],
                        ),
                      ))
                          .toList(),
                    )
        ],
      ),
    );
  }

  void fetchData() async {
    loading = true;
    setState(() {});
    List<Passenger> passengers = await PassengerApi.allMyPassengers();
    passengers.forEach((passenger) {
      if (!allPassengers.containsKey(passenger)) {
        allPassengers[passenger] = false;
      }
      if (widget.choose.contains(passenger)) {
        allPassengers[passenger] = true;
      }
    });
    loading = false;
    setState(() {});
  }
}
