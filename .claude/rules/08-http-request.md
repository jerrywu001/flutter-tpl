# HTTP 请求系统

## 概述

项目使用基于 `dio` 的 HTTP 请求封装，提供统一的请求管理、拦截器支持和错误处理。

## 文件结构

```
lib/api/
├── request/
│   ├── index.dart           # 导出文件
│   ├── http_types.dart      # 类型定义
│   └── http_request.dart    # 核心请求类
└── home/
    └── index.dart           # API 接口定义示例
```

## 初始化

在 `main.dart` 中初始化 HTTP 配置（只需一次）：

```dart
import 'package:ybx_parent_client/api/request/index.dart';

void main() {
  HttpRequest.init();
  runApp(const MyApp());
}
```

## 基本使用

### GET 请求

```dart
final response = await HttpRequest.get<Map<String, dynamic>>(
  '/user/info',
  queryParameters: {'id': '123'},
);

if (response.isSuccess) {
  SystemLog.info('用户信息: ${response.data}');
}
```

### POST 请求

```dart
final response = await HttpRequest.post<Map<String, dynamic>>(
  '/auth/login',
  data: {
    'username': 'user@example.com',
    'password': 'password123',
  },
);
```

### PUT/DELETE 请求

```dart
await HttpRequest.put<Map<String, dynamic>>('/user/info', data: {...});
await HttpRequest.delete<Map<String, dynamic>>('/user/123');
```

## 高级功能

### 自定义 Headers

```dart
final response = await HttpRequest.get<Map<String, dynamic>>(
  '/api/data',
  headers: {
    'X-Custom-Header': 'custom-value',
  },
);
```

### 可取消的请求

```dart
final cancelToken = CancelToken();

final response = await HttpRequest.get<Map<String, dynamic>>(
  '/api/long-request',
  cancelToken: cancelToken,
);

// 取消请求
cancelToken.cancel('用户取消了请求');
```

## API 定义最佳实践

创建独立的 API 函数（参考 `lib/api/home/index.dart`）：

```dart
/// 查询附近陪伴官列表
Future<CompanionListResponse> queryNearbyCompanions(
  QueryNearbyCompanionsParam params,
) async {
  try {
    final response = await HttpRequest.get<Map<String, dynamic>>(
      '/api/parent/companions',
      queryParameters: params.toJson(),
    );

    if (!response.isSuccess || response.code != HttpResponseCode.succeed.code) {
      throw response.message ?? '服务器错误';
    }

    if (response.isSuccess && response.code == HttpResponseCode.succeed.code) {
      return CompanionListResponse.fromJson(response.data ?? {});
    }
  } catch (e) {
    rethrow;
  }

  // 返回空列表
  return CompanionListResponse(
    list: const [],
    total: 0,
    page: params.page,
    size: params.size,
    totalPages: 0,
  );
}
```

### 关键点

1. 使用独立函数而非类的静态方法
2. 使用 try-catch 包裹请求
3. 检查 `response.isSuccess` 和 `response.code`
4. 使用 `HttpResponseCode.succeed.code` 判断成功
5. 失败时抛出异常
6. 在 API 函数内部进行类型转换

## 在组件中使用

参考 `lib/pages/home/home_screen.dart`：

```dart
Future<void> fetchNearbyCompanions() async {
  try {
    final result = await queryNearbyCompanions(
      QueryNearbyCompanionsParam(page: 1, size: 10),
    );

    if (result.list.isNotEmpty) {
      for (final item in result.list) {
        SystemLog.error('用户ID: ${item.userId}');
      }
    }
  } catch (e) {
    SystemLog.error(e.toString());
  }
}

@override
void initState() {
  super.initState();
  fetchNearbyCompanions();
}
```

### 关键点

1. 使用 try-catch 捕获异常
2. 使用 SystemLog 记录错误和调试信息
3. API 函数返回类型化的响应对象，直接使用

## HttpResponse 属性

- `code` - 状态码
- `message` - 消息
- `data` - 响应数据
- `headers` - 响应头
- `isSuccess` - 是否成功（getter）

## 注意事项

1. 只需在 `main.dart` 中初始化一次
2. 拦截器在初始化时设置，对所有请求自动生效
3. 建议将 API 调用封装到独立的 API 函数中
4. 在 API 函数内部进行类型转换和错误处理
5. 文件上传下载可直接使用 `HttpRequest.dio` 获取 Dio 实例
