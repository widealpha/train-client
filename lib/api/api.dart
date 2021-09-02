import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:train/bean/train.dart';
import 'package:train/bean/user_info.dart';
import 'package:train/util/hive_util.dart';

final String host = 'https://widealpha.top:8443/train';

class Connection {
  static Dio? _dio;

  static Dio get dio {
    _dio ??= Dio(BaseOptions(responseType: ResponseType.json));
    return _dio!;
  }

  static Options get options =>
      Options(headers: {'Authorization': 'Bearer ${HiveUtils.get('token')}'});
}

class UserApi {
  static String _login = host + '/user/login';
  static String _register = host + '/user/register';
  static String _userInfo = host + '/userInfo/myInfo';

  static bool isLogin() {
    return HiveUtils.get('token') != null;
  }

  static Future<String> login(username, password) async {
    Response response = await Connection.dio.post(_login,
        queryParameters: {'username': username, 'password': password});
    if (response.statusCode == 200 && response.data['code'] == 0) {
      HiveUtils.set('token', response.data['data']);
      response =
          await Connection.dio.post(_userInfo, options: Connection.options);
      UserInfo userInfo = UserInfo.fromJson(response.data['data']);
      HiveUtils.set('user_id', userInfo.userId);
      HiveUtils.set('head_image', userInfo.headImage);
      HiveUtils.set('nickname', userInfo.nickname);
      Get.forceAppUpdate();
      return '登录成功';
    } else {
      return response.data['message'];
    }
  }

  static Future<String> register(String username, String password) async {
    Response response = await Connection.dio.post(_register,
        queryParameters: {'username': username, 'password': password});
    if (response.statusCode == 200 && response.data['code'] == 0) {
      return '注册成功';
    } else {
      return response.data['message'];
    }
  }

  static bool logout() {
    HiveUtils.remove('token');
    HiveUtils.remove('user_id');
    HiveUtils.remove('head_image');
    HiveUtils.remove('nickname');
    Get.forceAppUpdate();
    return true;
  }

  static UserInfo get userInfo {
    UserInfo userInfo = UserInfo();
    if (isLogin()) {
      userInfo.userId = HiveUtils.get('user_id');
      userInfo.headImage = HiveUtils.get('head_image');
      userInfo.nickname = HiveUtils.get('nickname');
    }
    return userInfo;
  }

  // static UserInfo userInfoDetail() async{
  //
  // }
}

class TrainApi{
  static String _trainInfo = host + '/train/trainInfo';
  static String _allTrains = host + '/train/allTrains';

  static Future<List<Train>> trainInfo(int train) async{
    // Response response = await Connection.dio.post
    return [];
  }
}
