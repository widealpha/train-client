import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:train/api/api.dart';
import 'package:train/bean/coach.dart';
import 'package:train/bean/passenger.dart';
import 'package:train/bean/seat_type.dart';
import 'package:train/bean/ticket.dart';
import 'package:train/util/date_util.dart';

class SelfTicketPage extends StatefulWidget {
  const SelfTicketPage({Key? key}) : super(key: key);

  @override
  _SelfTicketPageState createState() => _SelfTicketPageState();
}

class _SelfTicketPageState extends State<SelfTicketPage> {
  Map<Ticket, Coach> coachMap = {};
  Map<Ticket, String> seatMap = {};
  Map<String, String> seatTypeCodeToName = {};
  Map<Ticket, Passenger> passengerMap = {};
  List<Ticket> tickets = [];
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
    } else  {
      return ListView(
        children: buildCardList(),
      );
    }
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
          ],
        ),
      ));
    });
    return widgets;
  }

  void fetchData() async {
    loading = true;
    setState(() {});
    tickets = await TicketApi.allSelfTicket();
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
    loading = false;
    setState(() {});
  }
}