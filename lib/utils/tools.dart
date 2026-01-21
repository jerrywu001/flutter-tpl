import 'size_fit.dart';

extension NumFit on num {
  double get rpx => SizeFit.setRpx(toDouble());
}

/// 格式化日期
///
/// [date] 日期
///
/// 返回格式化后的日期字符串
String formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

/// 验证邮箱
///
/// [email] 邮箱字符串
///
/// 返回是否为有效邮箱
bool isValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

/// 防抖函数
///
/// [func] 要执行的函数
///
/// [delay] 防抖延迟时间
///
/// 返回防抖后的函数
Function debounce(Function func, Duration delay) {
  DateTime? lastExecute;
  return () {
    final now = DateTime.now();
    if (lastExecute == null || now.difference(lastExecute!) > delay) {
      lastExecute = now;
      func();
    }
  };
}

/// 格式化金额字符串
///
/// [moneyString] 金额（字符串或数字）
///
/// 返回格式化后的金额字符串，如 "1,234.56"
String formatMoneyString(dynamic moneyString) {
  if (moneyString == null) return '';

  final value = double.tryParse(moneyString.toString());
  if (value == null) return '';

  // 保留两位小数
  final formatted = value.toStringAsFixed(2);

  // 分割整数和小数部分
  final parts = formatted.split('.');
  final intPart = parts[0];
  final decPart = parts.length > 1 ? parts[1] : '00';

  // 每三位加逗号
  final buffer = StringBuffer();
  for (var i = 0; i < intPart.length; i++) {
    if (i > 0 && (intPart.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(intPart[i]);
  }

  return '${buffer.toString()}.$decPart';
}

/// 手机号脱敏
///
/// [phone] 手机号
///
/// 返回脱敏后的手机号，如 "138 **** 8888"
String desensitizePhone(String? phone) {
  if (phone == null || phone.isEmpty) return '';

  return phone.replaceAllMapped(
    RegExp(r'(\d{3})(\d{4})(\d{4})'),
    (match) => '${match[1]} **** ${match[3]}',
  );
}

/// 身份证号脱敏
///
/// [ssnId] 身份证号
///
/// 返回脱敏后的身份证号，保留前三位和后四位，如 "310 ******** 1234"
String processSSNId(String? ssnId) {
  if (ssnId == null || ssnId.isEmpty) return '';

  return ssnId.replaceAllMapped(
    RegExp(r'(\d{3})\d*(\d{4})'),
    (match) => '${match[1]} ******** ${match[2]}',
  );
}

/// 银行卡号每四位插入空格
///
/// [cardNumber] 银行卡号
///
/// 返回格式化后的银行卡号，如 "6217 0000 0000 6608"
String addBlankToCardNumber(String? cardNumber) {
  if (cardNumber == null || cardNumber.isEmpty) return '';

  return cardNumber.replaceAllMapped(
    RegExp(r'(\d{4})(?=\d)'),
    (match) => '${match[1]} ',
  );
}

/// 银行卡号脱敏
///
/// [cardNumber] 银行卡号
///
/// 返回脱敏后的银行卡号，如 "6217 **** **** 6608"
String processCardNumber(String? cardNumber) {
  if (cardNumber == null || cardNumber.isEmpty) return '';

  return cardNumber.replaceAllMapped(
    RegExp(r'(\d{4})\d*(\d{4})'),
    (match) => '${match[1]} **** **** ${match[2]}',
  );
}
