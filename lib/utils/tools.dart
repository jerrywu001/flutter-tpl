import 'package:flutter/material.dart';

class Tools {
  /// 显示消息提示
  ///
  /// [context] 上下文
  ///
  /// [message] 消息内容
  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  /// 显示确认对话框
  static Future<bool?> showConfirm(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 格式化日期
  ///
  /// [date] 日期
  ///
  /// 返回格式化后的日期字符串
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// 验证邮箱
  ///
  /// [email] 邮箱字符串
  ///
  /// 返回是否为有效邮箱
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// 防抖函数
  ///
  /// [func] 要执行的函数
  ///
  /// [delay] 防抖延迟时间
  ///
  /// 返回防抖后的函数
  static Function debounce(Function func, Duration delay) {
    DateTime? lastExecute;
    return () {
      final now = DateTime.now();
      if (lastExecute == null || now.difference(lastExecute!) > delay) {
        lastExecute = now;
        func();
      }
    };
  }
}
