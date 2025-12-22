import 'package:dio/dio.dart';
import 'package:ybx_parent_client/utils/index.dart';

import 'http_types.dart';

/// 请求拦截回调
typedef OnRequestCallback = void Function(RequestOptions options);

/// 响应拦截回调
typedef OnResponseCallback = void Function(Response response);

/// 错误拦截回调
typedef OnErrorCallback = void Function(DioException error);

/// HTTP 请求封装类
class HttpRequest {
  HttpRequest._();

  static final HttpRequest _instance = HttpRequest._();
  static HttpRequest get instance => _instance;

  late Dio _dio;
  late HttpConfig _config;

  /// 初始化
  static void init() {
    const printError = true;
    const timeout = Duration(seconds: 30);
    const hostUrl = String.fromEnvironment('API_HOST');

    SystemLog.success('\n API HOST URL 🎉⬇️');
    SystemLog.info(hostUrl);

    _instance._config = HttpConfig(
      baseUrl: hostUrl,
      timeout: timeout,
      printError: printError,
    );

    _instance._dio = Dio(
      BaseOptions(
        baseUrl: _instance._config.baseUrl,
        connectTimeout: _instance._config.connectTimeout,
        receiveTimeout: _instance._config.receiveTimeout,
        sendTimeout: _instance._config.timeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // 添加拦截器
    _instance._setupInterceptors();
  }

  /// 设置拦截器
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          _handleError(error);
          handler.next(error);
        },
      ),
    );
  }

  /// 处理错误
  void _handleError(DioException error) {
    String message = '';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = '请求超时';
        break;
      case DioExceptionType.badResponse:
        message = _handleStatusCode(error.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        message = '请求已取消';
        break;
      default:
        message = '网络异常，请稍后重试';
    }

    if (_config.printError) {
      SystemLog.error('HTTP Error: $message');
    }
  }

  /// 处理状态码
  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 401:
        return '未授权，请重新登录';
      case 403:
        return '拒绝访问';
      case 404:
        return '请求地址不存在';
      case 408:
        return '请求超时';
      case 500:
        return '服务器错误';
      case 502:
        return '网关错误';
      case 503:
        return '服务不可用';
      case 504:
        return '网关超时';
      default:
        return '请求失败';
    }
  }

  /// 通用请求方法
  static Future<HttpResponse<T>> request<T>(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJsonT,
    CancelToken? cancelToken,
  }) async {
    // TODO: 从本地缓存中获取 token
    const token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJlZmJjNjlmOS1jNWZjLTQ1YzgtOGI5ZC1jZWIzMDU4ODU5MGQiLCJ1c2VyVHlwZSI6InBhcmVudCIsIm9wZW5JZCI6Im8zYmR1M1lHZzR5U21FS244V1dOX0paVm5LbE0iLCJpYXQiOjE3Njg3MzcwNzAsImV4cCI6MTc2OTM0MTg3MH0.1GgccB-XRuyame3wdy-kiMVnHagax_NBpc3d4q3Yvkg';

    headers ??= {};
    headers['Authorization'] = 'Bearer $token';

    SystemLog.success('\n $method:  $path');
    SystemLog.success('🚀 queryParameters:  $queryParameters');
    SystemLog.success('🍥 headers:  $headers');

    try {
      final response = await _instance._dio.request(
        path,
        queryParameters: queryParameters,
        data: data,
        options: Options(method: method, headers: headers),
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      return HttpResponse<T>(
        code: e.response?.statusCode.toString() ?? '-1',
        message: e.message ?? '请求失败',
        data: null,
      );
    }
  }

  /// 处理响应
  static HttpResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJsonT,
  ) {
    SystemLog.info('Response: $response \n');

    final data = response.data ?? response.context;

    // 如果响应数据是标准格式 {code, message, data}
    if (data is Map<String, dynamic> &&
        data.containsKey('code') &&
        data.containsKey('message')) {
      return HttpResponse<T>.fromJson(data, fromJsonT);
    }

    // 如果响应数据不是标准格式，直接返回
    return HttpResponse<T>(
      code: HttpResponseCode.succeed.code,
      message: 'success',
      data: fromJsonT != null ? fromJsonT(data) : data as T?,
    );
  }

  /// GET 请求
  static Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJsonT,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      headers: headers,
      fromJsonT: fromJsonT,
      cancelToken: cancelToken,
    );
  }

  /// POST 请求
  static Future<HttpResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJsonT,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      fromJsonT: fromJsonT,
      cancelToken: cancelToken,
    );
  }

  /// PUT 请求
  static Future<HttpResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJsonT,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      fromJsonT: fromJsonT,
      cancelToken: cancelToken,
    );
  }

  /// DELETE 请求
  static Future<HttpResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJsonT,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      fromJsonT: fromJsonT,
      cancelToken: cancelToken,
    );
  }

  /// 获取 Dio 实例（用于特殊场景，如文件上传下载）
  static Dio get dio => _instance._dio;
}
