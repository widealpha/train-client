import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train/api/api.dart';
import 'package:train/bean/passenger.dart';

class AddPassengerPage extends StatefulWidget {
  const AddPassengerPage({Key? key}) : super(key: key);

  @override
  _AddPassengerPageState createState() => _AddPassengerPageState();
}

class _AddPassengerPageState extends State<AddPassengerPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _typeController = TextEditingController(text: '成人');
  TextEditingController _phoneController = TextEditingController();
  String? _nameError;
  String? _idError;
  String? _phoneError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择乘车人'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.drive_file_rename_outline_rounded),
                        border: OutlineInputBorder(),
                        hintText: '请输入真实姓名以便购票',
                        labelText: '姓名',
                        errorText: _nameError),
                    focusNode: FocusNode()..requestFocus(),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.credit_card_outlined),
                        border: OutlineInputBorder(),
                        hintText: '请输入身份证号进行核验',
                        labelText: '证件号码',
                        errorText: _idError),
                  ),
                )),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.phone_android_rounded),
                        border: OutlineInputBorder(),
                        hintText: '请准确填写乘车人手机号',
                        labelText: '手机号码',
                        errorText: _phoneError),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _typeController,
                    readOnly: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.merge_type_rounded),
                        border: OutlineInputBorder(),
                        hintText: '请选择旅客类型',
                        labelText: '旅客类型',
                        suffixIcon: IconButton(
                            onPressed: () {
                              _typeController.text == '成人'
                                  ? _typeController.text = '学生'
                                  : _typeController.text = '成人';
                            },
                            icon: Icon(Icons.change_circle_rounded))),
                  ),
                )),
              ],
            ),
          ),
          Divider(thickness: 6),
          Padding(padding: EdgeInsets.all(8)),
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white, backgroundColor: Colors.blue),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text('确认', style: TextStyle(fontSize: 18))),
              onPressed: () async {
                String id = _idController.text;
                if (id.length != 18) {
                  _idError = '请检查证件号格式'; // 位数不够
                  setState(() {});
                  return;
                }
                RegExp exp = new RegExp(
                    r'^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|[Xx])$');
                if (!exp.hasMatch(id)) {
                  _idError = '请检查证件号格式';
                  setState(() {});
                  return;
                }

                String phone = _phoneController.text;
                exp = RegExp(
                    r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
                if (!exp.hasMatch(phone)) {
                  _phoneError = '请检查手机号格式';
                  setState(() {});
                  return;
                }
                String name = _nameController.text;
                if (name.isEmpty) {
                  _nameError = '姓名不能为空';
                  setState(() {});
                  return;
                }
                Passenger? passenger = Passenger(
                    name: name,
                    phone: phone,
                    idCardNo: id,
                    student: _typeController.text == '学生');
                passenger = await PassengerApi.addPassenger(passenger);
                if (passenger == null) {
                  return;
                } else {
                  Get.back(result: passenger);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
