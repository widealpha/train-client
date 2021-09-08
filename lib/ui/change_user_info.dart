import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train/api/api.dart';
import 'package:train/bean/user_info.dart';
import 'package:train/util/constance.dart';

class ChangeUserInfoPage extends StatefulWidget {
  final bool? notUseAppbar;
  const ChangeUserInfoPage({Key? key, this.notUseAppbar}) : super(key: key);

  @override
  _ChangeUserInfoPageState createState() => _ChangeUserInfoPageState();
}

class _ChangeUserInfoPageState extends State<ChangeUserInfoPage> {
  UserInfo userInfo = UserApi.userInfo;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _idCardController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _mailsController = TextEditingController();
  TextEditingController _typeController = TextEditingController(text: '男');
  TextEditingController _phoneController = TextEditingController();
  String? _nameError;
  String? _idError;
  String? _nicknameError;
  String? _mailError;
  String? _phoneError;

  @override
  void initState() {
    UserApi.userInfoDetail().then((info) {
      _nameController.text = info.realName ?? _nameController.text;
      _idCardController.text = info.idCardNo ?? _idCardController.text;
      _mailsController.text = info.mail ?? _mailsController.text;
      _phoneController.text = info.phone ?? _phoneController.text;
      _typeController.text = (info.gender ?? 0) == 0 ? '男' : '女';
      userInfo = info;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.notUseAppbar == null ? AppBar(
        title: Text('修改个人信息'),
        centerTitle: true,
      ) : null,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: GestureDetector(
              child: SizedBox(
                width: Constants.iconSize,
                height: Constants.iconSize,
                child: ClipOval(
                  child: Image.network(UserApi
                      .userInfo.headImage ??
                      'https://widealpha.top/images/default.jpg'),
                ),
              ),
              onTap: () async {
                FilePickerResult? r = await FilePicker.platform.pickFiles(
                  allowedExtensions: ['jpg','png']
                );
                if (r != null){
                  File file = File(r.files.single.path);
                  String s = await UserApi.uploadHeadImage(file.readAsBytesSync());

                  if (s.isNotEmpty){
                    UserApi.userInfo.headImage = s;
                    userInfo.headImage = s;
                    await UserApi.updateUserInfo(userInfo);
                    fetchData();

                    clearMemoryImageCache();
                    await clearDiskCachedImages();
                    Get.appUpdate();
                  }
                }
              },
            ),
          ),
          Center(child: Text('点击修改头像', style: TextStyle(color: Colors.grey),),),
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
                    controller: _idCardController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.credit_card_outlined),
                        border: OutlineInputBorder(),
                        hintText: '请输入个人身份证号',
                        labelText: '身份证号',
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
                    controller: _nicknameController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.drive_file_rename_outline_rounded),
                        border: OutlineInputBorder(),
                        hintText: '请输入昵称',
                        labelText: '昵称',
                        errorText: _nicknameError),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _mailsController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.drive_file_rename_outline_rounded),
                        border: OutlineInputBorder(),
                        hintText: '请输入个人邮箱',
                        labelText: '邮箱',
                        errorText: _mailError),
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
                        hintText: '请选择性别',
                        labelText: '性别',
                        suffixIcon: IconButton(
                            onPressed: () {
                              _typeController.text == '男'
                                  ? _typeController.text = '女'
                                  : _typeController.text = '男';
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
                String id = _idCardController.text;
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
                if (_nameController.text.isNotEmpty) {
                  userInfo.realName = _nameController.text;
                }
                if (_mailsController.text.isNotEmpty) {
                  userInfo.mail = _mailsController.text;
                }
                if (_phoneController.text.isNotEmpty) {
                  userInfo.phone = _phoneController.text;
                }
                if (_idCardController.text.isNotEmpty) {
                  userInfo.idCardNo = _idCardController.text;
                }
                if (_nicknameController.text.isNotEmpty) {
                  userInfo.nickname = _nicknameController.text;
                }
                await UserApi.updateUserInfo(userInfo);
                userInfo = await UserApi.userInfoDetail();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  fetchData() async{
    userInfo = await  UserApi.userInfoDetail();
    _nameController.text = userInfo.realName ?? _nameController.text;
    _idCardController.text = userInfo.idCardNo ?? _idCardController.text;
    _mailsController.text = userInfo.mail ?? _mailsController.text;
    _phoneController.text = userInfo.phone ?? _phoneController.text;
    _typeController.text = (userInfo.gender ?? 0) == 0 ? '男' : '女';
    _idError = null;
    _nameError = null;
    _mailError = null;
    _phoneError = null;
    setState(() {});
  }
}
