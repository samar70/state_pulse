import 'storage.dart';

class StatePulse {
  static Future<void> initialize() async {
    await StatePulseStorage.init();
  }
}
