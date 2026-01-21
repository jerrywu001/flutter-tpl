import 'dart:convert';

import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/foundation.dart';

/// 系统日志工具类
/// Android 使用 ANSI 颜色代码，iOS加标签显示
class SystemLog {
  static void success(String message) {
    if (kDebugMode) {
      _log(message, TextColor.green, '✅ SUCCESS');
    }
  }

  static void error(String message) {
    if (kDebugMode) {
      _log(message, TextColor.red, '❌ ERROR');
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      _log(message, TextColor.blue, 'ℹ️ INFO');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      _log(message, TextColor.yellow, '⚠️ WARNING');
    }
  }

  /// 打印 JSON 数据
  /// [pretty] 是否美化格式，默认为 true
  static void json(dynamic data, {String? label, bool pretty = true}) {
    if (kDebugMode) {
      try {
        String jsonStr;
        if (pretty) {
          const encoder = JsonEncoder.withIndent('  ');
          jsonStr = encoder.convert(data);
        } else {
          jsonStr = jsonEncode(data);
        }

        if (label != null) {
          _log(label, TextColor.cyan, '📦 JSON');
        }

        // 分段打印避免截断（Flutter print 限制约 1000 字符）
        _printLongText(jsonStr, TextColor.cyan);
      } catch (e) {
        _log('JSON 解析失败: $data', TextColor.red, '❌ ERROR');
      }
    }
  }

  /// 分段打印长文本，避免被截断
  static void _printLongText(String text, String color) {
    const chunkSize = 800;
    for (var i = 0; i < text.length; i += chunkSize) {
      final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
      _log(text.substring(i, end), color, '');
    }
  }

  static void _log(String message, String color, String label) {
    // iOS 不支持 ANSI 颜色代码，使用普通 print 加标签
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      if (kDebugMode) {
        if (label.isNotEmpty) {
          print('$label: $message');
        } else {
          print(message);
        }
      }
    } else {
      // Android 和其他平台使用 colorful_print
      if (label.isNotEmpty) {
        printColor('$label: $message', textColor: color);
      } else {
        printColor(message, textColor: color);
      }
    }
  }
}
