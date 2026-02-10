import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String userBoxName = 'users';
  static const String sessionBoxName = 'session';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(userBoxName);
    await Hive.openBox(sessionBoxName);
  }

  static Box get userBox => Hive.box(userBoxName);
  static Box get sessionBox => Hive.box(sessionBoxName);
}
