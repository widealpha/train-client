import 'package:bot_toast/bot_toast.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:train/api/api.dart';
import 'package:train/bean/station.dart';
import 'package:train/ui/station_page.dart';
import 'package:train/ui/train_page.dart';
import 'package:train/util/constance.dart';

import 'login.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _buildPage();
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
              child: UserApi.isLogin
                  ? GestureDetector(
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: SizedBox(
                                width: Constants.iconSize,
                                height: Constants.iconSize,
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
                                width: Constants.iconSize,
                                height: Constants.iconSize,
                                child: ClipOval(
                                  child: Icon(
                                    Icons.account_circle_rounded,
                                    size: Constants.iconSize,
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
            ListTile(
              title: Text('设置'),
              leading: Icon(Icons.settings),
            )
          ]..add(UserApi.isLogin
              ? ListTile(
                  leading: Icon(Icons.exit_to_app_rounded),
                  title: Text('切换账户'),
                  onTap: () {
                    UserApi.logout();
                    Get.to(() => LoginPage());
                  })
              : Container()),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        // 底部导航
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.train_rounded), label: '售票'),
          BottomNavigationBarItem(
              icon: Icon(Icons.airplane_ticket_rounded), label: '订单'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: '个人中心'),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildPage() {
    if (_pages.isEmpty) {
      _pages.add(TrainPage());
      _pages.add(Container(
        child: TextButton(
          child: Text('省份选择'),
          onPressed: () async {
            Station? s = await Get.to(() => StationPage());
            print(s);
          },
        ),
      ));
      _pages.add(Container(
        child: TextButton(
          child: Text('省份选择'),
          onPressed: () async {
            Station? s = await Get.to(() => StationPage());
            print(s);
          },
        ),
      ));
    }

    return _pages[_selectedIndex];
  }

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
