import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String boxName = 'tudeeBox';

  static Box get box => Hive.box(boxName);

  // حفظ بيانات
  static Future<void> saveData(String key, dynamic value) async {
    await box.put(key, value);
  }

  // قراءة بيانات
  static dynamic getData(String key) {
    return box.get(key);
  }

  // حذف بيانات
  static Future<void> deleteData(String key) async {
    await box.delete(key);
  }

  // حذف جميع البيانات
  static Future<void> clearData() async {
    await box.clear();
  }
}