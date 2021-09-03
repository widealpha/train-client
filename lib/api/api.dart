import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:train/bean/change_train.dart';
import 'package:train/bean/order.dart';
import 'package:train/bean/pager.dart';
import 'package:train/bean/remain_seat.dart';
import 'package:train/bean/seat_type.dart';
import 'package:train/bean/station.dart';
import 'package:train/bean/ticket.dart';
import 'package:train/bean/train.dart';
import 'package:train/bean/train_class.dart';
import 'package:train/bean/train_price.dart';
import 'package:train/bean/train_station.dart';
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

  static bool get isLogin => HiveUtils.get('token') != null;

  static Future<String> login(username, password) async {
    Response response = await Connection.dio.post(_login,
        queryParameters: {'username': username, 'password': password});
    if (response.statusCode == 200 && response.data['code'] == 0) {
      await HiveUtils.set('token', response.data['data']);
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
    if (isLogin) {
      userInfo.userId = HiveUtils.get('user_id');
      userInfo.headImage = HiveUtils.get('head_image');
      userInfo.nickname = HiveUtils.get('nickname');
    }
    return userInfo;
  }

  static Future<UserInfo> userInfoDetail() async {
    Response response = await Connection.dio.post(_userInfo,
        options: Connection.options);
    if (response.data['code'] == 0) {
      return UserInfo.fromJson(response.data['data']);
    }
    return userInfo;
  }
}

class TrainApi {
  static String _trainInfo = host + '/train/trainInfo';
  static String _allTrains = host + '/train/allTrains';
  static String _trainsBetween = host + '/train/trainsBetween';
  static String _trainsBetweenWithChange =
      host + '/train/trainsBetweenWithChange';
  static String _trainPrice = host + '/train/price';
  static String _trainTicketRemaining = host + '/train/trainTicketRemaining';
  static String _trainStations = host + '/train/trainStations';

  static Future<Train?> trainInfo(String stationTrainCode) async {
    Response response = await Connection.dio.post(_trainInfo,
        queryParameters: {'stationTrainCode': stationTrainCode},
        options: Connection.options);
    if (response.data['code'] == 0) {
      return Train.fromJson(response.data['data']);
    }
    return null;
  }

  static Future<Pager<Train>> allTrains(int page, int size) async {
    Response response = await Connection.dio.post(_allTrains,
        queryParameters: {'page': page, 'size': size},
        options: Connection.options);
    Pager<Train> pager = Pager(0, 0, 0, 0, []);
    if (response.data['code'] == 0) {
      List l = response.data['data']['rows'];
      pager.size = response.data['data']['size'];
      pager.page = response.data['data']['page'];
      pager.total = response.data['data']['total'];
      pager.rows = l.map((e) => Train.fromJson(e)).toList();
      if (pager.size == 0) {
        pager.totalPage = 0;
      }
      if (pager.totalSize % pager.size == 0) {
        pager.totalPage = pager.totalSize ~/ pager.size;
      }
      pager.totalPage = pager.totalSize ~/ pager.size + 1;
      return pager;
    }
    return Pager(0, 0, 0, 0, []);
  }

  static Future<List<Train>> trainsBetween(
      String startStationTelecode, String endStationTelecode) async {
    Response response = await Connection.dio.post(_trainsBetween,
        queryParameters: {
          'startStationTelecode': startStationTelecode,
          'endStationTelecode': endStationTelecode
        },
        options: Connection.options);
    if (response.data['code'] == 0) {
      List l = response.data['data'];
      return l.map((e) => Train.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<ChangeTrain>> trainsBetweenWithChange(
      String startStationTelecode, String endStationTelecode) async {
    Response response = await Connection.dio.post(_trainPrice,
        queryParameters: {
          'startStationTelecode': startStationTelecode,
          'endStationTelecode': endStationTelecode
        },
        options: Connection.options);
    if (response.data['code'] == 0) {
      List l = response.data['data'];
      return l.map((e) => ChangeTrain.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<TrainPrice>> trainPrice(
      String startStationTelecode, String endStationTelecode) async {
    Response response = await Connection.dio.post(_trainsBetweenWithChange,
        queryParameters: {
          'startStationTelecode': startStationTelecode,
          'endStationTelecode': endStationTelecode
        },
        options: Connection.options);
    if (response.data['code'] == 0) {
      List l = response.data['data'];
      return l.map((e) => TrainPrice.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<RemainSeat>> trainTicketRemaining(
      String startStationTelecode, String endStationTelecode) async {
    Response response = await Connection.dio.post(_trainTicketRemaining,
        queryParameters: {
          'startStationTelecode': startStationTelecode,
          'endStationTelecode': endStationTelecode
        },
        options: Connection.options);
    if (response.data['code'] == 0) {
      List l = response.data['data'];
      return l.map((e) => RemainSeat.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<TrainStation>> trainStations(
      String stationTrainCode) async {
    Response response = await Connection.dio.post(_trainStations,
        queryParameters: {'stationTrainCode': stationTrainCode},
        options: Connection.options);
    if (response.data['code'] == 0) {
      List l = response.data['data'];
      return l.map((e) => TrainStation.fromJson(e)).toList();
    }
    return [];
  }
}

class StationApi {
  static String _allStations = host + '/station/allStations';
  static String _stationInfo = host + '/station/info';

  static List<Station> _stationCache = [];

  static Future<List<Station>> allStations() async {
    if (_stationCache.isNotEmpty) {
      return _stationCache;
    }
    Response response =
        await Connection.dio.post(_allStations, options: Connection.options);
    if (response.data['code'] == 0) {
      List l = response.data['data'];
      _stationCache = l.map((e) => Station.fromJson(e)).toList();
      return _stationCache;
    }
    return _stationCache;
  }

  static Future<Station?> stationInfo(String stationTelecode) async {
    if (_stationCache.isNotEmpty) {
      for (Station value in _stationCache) {
        if (value.telecode == stationTelecode) {
          return value;
        }
      }
    }
    Response response =
        await Connection.dio.post(_stationInfo, options: Connection.options);
    if (response.data['code'] == 0) {
      return Station.fromJson(response.data['data']);
    }
    return null;
  }
}

class SeatTypeApi {
  static String _allSeatTypes = host + '/seatType/seatTypes';

  static Future<List<SeatType>> allSeatTypes() async {
    Response response =
        await Connection.dio.post(_allSeatTypes, options: Connection.options);
    if (response.data['code'] == 0) {
      List l = response.data['data'];
      return l.map((e) => SeatType.fromJson(e)).toList();
    }
    return [];
  }
}

class TrainClassApi {
  static String _allTrainClasses = host + '/trainClass/trainClass';

  static Future<List<TrainClass>> allTrainClasses() async {
    Response response = await Connection.dio
        .post(_allTrainClasses, options: Connection.options);
    if (response.data['code'] == 0) {
      List l = response.data['data'];
      return l.map((e) => TrainClass.fromJson(e)).toList();
    }
    return [];
  }
}

class TicketApi {
  static String _allMyTickets = host + "/ticket/userTickets";
  static String _buyTicket = host + "/ticket/buyTicket";
  static String _cancelTicket = host + "/ticket/cancelTicket";
  static String _ticketInfo = host + "/ticket/ticketInfo";

  static Future<List<Ticket>> allMyTicket() async {
    Response response =
        await Connection.dio.post(_allMyTickets, options: Connection.options);
    if (response.data['code'] == 0) {
      List l = response.data['data'];
      return l.map((e) => Ticket.fromJson(e)).toList();
    }
    return [];
  }

  static Future<int?> buyTicket(
      String startStationTelecode,
      String endStationTelecode,
      String stationTrainCode,
      String seatTypeCode,
      num passengerId,
      bool student,
      String date) async {
    Response response = await Connection.dio
        .post(_buyTicket, options: Connection.options, queryParameters: {
      'startStationTelecode': startStationTelecode,
      'endStationTelecode': endStationTelecode,
      'stationTrainCode': stationTrainCode,
      'seatTypeCode': seatTypeCode,
      'passengerId': passengerId,
      'student': student,
      'date': date
    });
    if (response.data['code'] == 0) {
      return response.data['data'];
    }
    return null;
  }

  static Future<bool> cancelTicket(int ticketId) async {
    Response response = await Connection.dio.post(_cancelTicket,
        options: Connection.options, queryParameters: {'ticketId': ticketId});
    if (response.data['code'] == 0) {
      return response.data['data'];
    }
    return false;
  }

  static Future<Ticket?> ticketInfo(int ticketId) async {
    Response response = await Connection.dio.post(_ticketInfo,
        options: Connection.options, queryParameters: {'ticketId': ticketId});
    if (response.data['code'] == 0) {
      return response.data['data'];
    }
    return null;
  }
}

class OrderFormApi {
  static String _allMyOrders = host + "/orderForm/myOrderForms";
  static String _payOrderForm = host + "/orderForm/payOrderForm";

  static Future<List<Order>> allMyOrders() async {
    Response response =
        await Connection.dio.post(_allMyOrders, options: Connection.options);
    if (response.data['code'] == 0) {
      List l = response.data['data'];
      return l.map((e) => Order.fromJson(e)).toList();
    }
    return [];
  }

  static Future<String?> payOrderForm(int orderId) async {
    Response response =
        await Connection.dio.post(_payOrderForm, options: Connection.options);
    if (response.data['code'] == 0) {
      return response.data['data'];
    }
    return null;
  }
}
