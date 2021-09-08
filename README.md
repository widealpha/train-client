# train

火车票售票系统(模拟12306).

## Getting Started 安装flutter
1. 按照flutter官方教程安装flutter框架 https://flutter.dev/docs/get-started/install
2. 更改api.dart文件中的全局变量host(默认127.0.0.1:8080)为目前运行train-server的ip地址和端口
3. 确保train-server已经启动成功
4. 启动已经打好的release包,或执行flutter build重新打包(部分地方用到了dart.io包,排除后即可运行在网页端)

## 用到dart.io的位置
1. 上传头像 change_user_info.dart
2. constant.dart

## 运行平台代码
需要在项目文件夹下执行
1. windows平台: flutter build windows
2. 安卓平台: flutter build android
3. etc...

### 一些运行截图
![image](https://user-images.githubusercontent.com/57834237/132506041-9c077297-e3fb-4195-983b-fbba3eeaf67e.png)
![image](https://user-images.githubusercontent.com/57834237/132506146-d23405e0-7432-4fd2-be78-7e55362eb481.png)
![image](https://user-images.githubusercontent.com/57834237/132506178-a916cc63-40f2-4a40-9539-3a7ad41f8ae3.png)
![image](https://user-images.githubusercontent.com/57834237/132506402-07ea3804-a255-49b0-ad44-3ebd9cb01483.png)
![image](https://user-images.githubusercontent.com/57834237/132506228-eed968df-b3df-4b7e-acc8-2267f1f4391b.png)
![image](https://user-images.githubusercontent.com/57834237/132506316-c8bc530a-1878-40fd-b279-f24119f04491.png)
![image](https://user-images.githubusercontent.com/57834237/132506466-1930476a-93e8-455d-a837-e779f712275c.png)
![image](https://user-images.githubusercontent.com/57834237/132506551-55ff5094-2fed-4bdb-8115-7634d8254478.png)
![image](https://user-images.githubusercontent.com/57834237/132506598-e30e152e-380c-4ff7-986e-b5a2870bda61.png)
![image](https://user-images.githubusercontent.com/57834237/132506693-a8bf3b79-295e-4c66-88a6-5ea1893c13a3.png)
![image](https://user-images.githubusercontent.com/57834237/132506752-a0183c89-455d-4982-b722-3c98fc8b0ada.png)
![image](https://user-images.githubusercontent.com/57834237/132506790-a1c630bb-04e0-4e90-b514-346f076aec7e.png)
