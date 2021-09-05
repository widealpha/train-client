import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train/ui/pay_order.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          child: Text(
            '订单管理',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
          ),
        ),
        Divider(),
        Row(
          children: [
            Expanded(
              child: InkWell(
                child: Column(
                  children: [
                    Icon(Icons.pending_actions_rounded,
                        size: 32, color: Colors.blueAccent),
                    Text('待支付')
                  ],
                ),
                onTap: () {
                  Get.to(() => NeedToPayPage());
                },
              ),
            ),
            Expanded(
              child: InkWell(
                child: Column(
                  children: [
                    Icon(Icons.list_alt_rounded,
                        size: 32, color: Colors.blueAccent),
                    Text('已支付')
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                child: Column(
                  children: [
                    Icon(Icons.sticky_note_2_rounded,
                        size: 32, color: Colors.blueAccent),
                    Text('本人车票')
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
