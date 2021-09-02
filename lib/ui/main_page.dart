import 'package:bot_toast/bot_toast.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train/api/api.dart';

import 'login.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('火车购票系统'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child: UserApi.isLogin()
                  ? GestureDetector(
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: SizedBox(
                                width: 100.0,
                                height: 100.0,
                                child: ClipOval(
                                  child: ExtendedImage.network(UserApi
                                          .userInfo.headImage ??
                                      'https://widealpha.top/images/default.jpg'),
                                ),
                              ),
                            ),
                          ),
                          Center(
                              child: Text(
                            UserApi.userInfo.nickname ?? '没有昵称',
                            style: TextStyle(color: Colors.white),
                          ))
                        ],
                      ),
                      onTap: () {
                        Get.dialog(AlertDialog(
                          title: Text('退出账号'),
                          content: Text('确认退出账号?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('取消'),
                            ),
                            TextButton(
                              onPressed: () {
                                UserApi.logout();
                                BotToast.showText(text: '成功退出账户');
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text('确定'),
                            ),
                          ],
                        ));
                      },
                    )
                  : GestureDetector(
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: SizedBox(
                                width: 100.0,
                                height: 100.0,
                                child: ClipOval(
                                  child: Icon(
                                    Icons.account_circle_rounded,
                                    size: 100,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                              child: Text(
                            '点击登录',
                            style: TextStyle(color: Colors.white),
                          ))
                        ],
                      ),
                      onTap: () {
                        Get.to(() => LoginPage());
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar( // 底部导航
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '售票'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: '订单'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: '个人中心'),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
}
