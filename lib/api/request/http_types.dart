/// HTTP 响应状态码
enum HttpResponseCode {
  /// 成功
  succeed('0'),

  /// 原始成功状态码
  originalSucceed('200'),

  /// 未授权
  unauthorized('401'),

  /// 拒绝访问
  rejected('403'),

  /// 未找到
  notFound('404'),

  /// 请求超时
  timeOut('408'),

  /// 服务器错误
  serverError('500');

  const HttpResponseCode(this.code);
  final String code;
}

/// HTTP 响应数据结构
class HttpResponse<T> {
  HttpResponse({
    required this.code,
    required this.message,
    this.data,
    this.headers,
  });

  /// 状态码
  final String code;

  /// 消息
  final String? message;

  /// 数据
  final T? data;

  /// 响应头
  final Map<String, dynamic>? headers;

  /// 是否成功
  bool get isSuccess =>
      code == HttpResponseCode.succeed.code ||
      code == HttpResponseCode.originalSucceed.code;

  factory HttpResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    final dynamic responseData = json['data'];

    return HttpResponse<T>(
      code: json['code']?.toString() ?? '-1',
      message: json['message']?.toString() ?? '',
      data: fromJsonT != null && responseData != null
          ? fromJsonT(responseData)
          : responseData as T?,
      headers: json['headers'] as Map<String, dynamic>?,
    );
  }
}

/// HTTP 配置
class HttpConfig {
  HttpConfig({
    this.baseUrl = '',
    this.timeout = const Duration(seconds: 30),
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.printError = false,
  });

  /// 基础 URL
  final String baseUrl;

  /// 超时时间
  final Duration timeout;

  /// 连接超时
  final Duration connectTimeout;

  /// 接收超时
  final Duration receiveTimeout;

  /// 是否显示错误提示
  final bool printError;
}

class HttpResponseException implements Exception {
  final String code;
  final String message;

  HttpResponseException({required this.code, required this.message});
}
