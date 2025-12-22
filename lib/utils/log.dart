import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/foundation.dart';

class SystemLog {
  static void success(String message) {
    if (kDebugMode) {
      printColor(message, textColor: TextColor.green);
    }
  }

  static void error(String message) {
    if (kDebugMode) {
      printColor(message, textColor: TextColor.red);
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      printColor(message, textColor: TextColor.blue);
    }
  }
}
