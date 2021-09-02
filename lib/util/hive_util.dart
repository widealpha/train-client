import 'package:hive_flutter/adapters.dart';

class HiveUtils {
  static late Box<String> _box;

  static Future<void> init() async {
    _box = await Hive.openBox<String>('user');
  }

  static set(String key, String value) {
    _box.put(key, value);
  }

  static get(String key) {
    return _box.get(key);
  }
}
