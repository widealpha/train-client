import 'package:dio/dio.dart';
import 'package:train/util/hive_util.dart';

final String host = 'https://widealpha.top:8443/train';

class Connection {
  static Dio? _dio;

  static Dio get dio {
    _dio ??= Dio(BaseOptions());
    return _dio!;
  }
}

class UserApi {
  static String _login = host + '/user/login';
  static String _register = host + '/user/register';

  static bool isLogin() {
    return HiveUtils.get('token') == null;
  }

  static Future<String> login(username, password) async {
    Response response = await Connection.dio.post(_login,
        queryParameters: {'username': username, 'password': password});
    if (response.statusCode == 200 && response.data['code'] == 0) {
      HiveUtils.set('token', response.data['token']);
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
}
