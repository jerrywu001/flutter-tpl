# HTTP 请求封装使用指南

## 概述

本项目的 HTTP 请求封装基于 `dio` 包，参考了 sales-admin 项目中的 axios 封装设计，提供了统一的请求管理、拦截器支持和错误处理。

## 文件结构

```
lib/utils/http/
├── http.dart              # 导出文件
├── http_types.dart        # 类型定义
└── http_request.dart      # 核心请求类
```

## 快速开始

### 1. 初始化配置（只需一次）

在 `main.dart` 中初始化 HTTP 配置，拦截器在初始化时设置，对所有请求自动生效：

```dart
import 'package:ybx_parent_client/utils/http/http.dart';

void main() {
  // 初始化 HTTP 配置和拦截器（只需调用一次）
  HttpRequest.init();

  runApp(const MyApp());
}
```

### 2. 直接使用（无需再次配置拦截器）

初始化后，所有请求都会自动应用拦截器：

```dart
// 直接发起请求，拦截器自动生效
final response = await HttpRequest.get<Map<String, dynamic>>(
  '/user/info',
  queryParameters: {'id': '123'},
);

if (response.isSuccess) {
  SystemLog.error('用户信息: ${response.data}');
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
} else {
  SystemLog.error('请求失败: ${response.message}');
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

if (response.isSuccess) {
  final token = response.data?['token'];
  // 保存 token
}
```

### PUT 请求

```dart
final response = await HttpRequest.put<Map<String, dynamic>>(
  '/user/info',
  data: {
    'name': '新名称',
    'email': 'new@example.com',
  },
);
```

### DELETE 请求

```dart
final response = await HttpRequest.delete<Map<String, dynamic>>(
  '/user/123',
);
```

## 高级用法

### 1. 自定义 Headers

```dart
final response = await HttpRequest.get<Map<String, dynamic>>(
  '/api/data',
  headers: {
    'X-Custom-Header': 'custom-value',
    'X-Request-ID': 'request-123',
  },
);
```

### 2. 类型转换

```dart
// 定义数据模型
class User {
  final String id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

// 使用类型转换
final response = await HttpRequest.get<List<User>>(
  '/users',
  fromJsonT: (json) {
    if (json is List) {
      return json.map((item) => User.fromJson(item)).toList();
    }
    return [];
  },
);

if (response.isSuccess && response.data != null) {
  for (final user in response.data!) {
    SystemLog.error('用户: ${user.name}');
  }
}
```

### 3. 可取消的请求

```dart
final cancelToken = CancelToken();

// 发起请求
final response = await HttpRequest.get<Map<String, dynamic>>(
  '/api/long-request',
  cancelToken: cancelToken,
);

// 在需要时取消请求
cancelToken.cancel('用户取消了请求');
```

### 4. 文件上传

```dart
final formData = FormData.fromMap({
  'file': await MultipartFile.fromFile(filePath),
  'description': '文件描述',
});

final response = await HttpRequest.post<Map<String, dynamic>>(
  '/upload',
  data: formData,
);
```

### 5. 文件下载

```dart
await HttpRequest.dio.download(
  'https://example.com/file.pdf',
  '/path/to/save/file.pdf',
  onReceiveProgress: (received, total) {
    if (total != -1) {
      SystemLog.error('下载进度: ${(received / total * 100).toStringAsFixed(0)}%');
    }
  },
);
```

## API 参考

### HttpConfig

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| baseUrl | String | '' | 基础 URL |
| timeout | Duration | 30s | 请求超时时间 |
| connectTimeout | Duration | 30s | 连接超时时间 |
| receiveTimeout | Duration | 30s | 接收超时时间 |
| printError | bool | false | 是否显示错误提示 |

### HttpResponse

| 属性 | 类型 | 说明 |
|------|------|------|
| code | String | 状态码 |
| message | String | 消息 |
| data | T? | 响应数据 |
| headers | Map? | 响应头 |
| isSuccess | bool | 是否成功 |

### HttpRequest 方法

#### get<T>()
- `path`: 请求路径
- `queryParameters`: 查询参数
- `headers`: 自定义请求头
- `fromJsonT`: 数据转换函数
- `cancelToken`: 取消令牌

#### post<T>()
- `path`: 请求路径
- `data`: 请求体数据
- `queryParameters`: 查询参数
- `headers`: 自定义请求头
- `fromJsonT`: 数据转换函数
- `cancelToken`: 取消令牌

#### put<T>()
参数同 `post<T>()`

#### delete<T>()
参数同 `post<T>()`

## 最佳实践

### 1. 统一的 API 管理

创建 API 管理类：

```dart
class UserApi {
  static Future<HttpResponse<User>> getUserInfo(String userId) {
    return HttpRequest.get<User>(
      '/user/$userId',
      fromJsonT: (json) => User.fromJson(json),
    );
  }

  static Future<HttpResponse<void>> updateUser(User user) {
    return HttpRequest.put<void>(
      '/user/${user.id}',
      data: user.toJson(),
    );
  }
}
```

### 2. 错误处理

```dart
try {
  final response = await HttpRequest.get<Map<String, dynamic>>('/api/data');

  if (response.isSuccess) {
    // 处理成功响应
  } else {
    // 处理业务错误
    TDToast.showText(response.message, context: context);
  }
} catch (e) {
  // 处理异常
  TDToast.showFail('请求失败，请稍后重试', context: context);
}
```

### 3. 加载状态管理

```dart
bool isLoading = false;

Future<void> loadData() async {
  setState(() => isLoading = true);

  try {
    final response = await HttpRequest.get<Map<String, dynamic>>('/api/data');
    if (response.isSuccess) {
      // 处理数据
    }
  } finally {
    setState(() => isLoading = false);
  }
}
```

## 与 sales-admin axios 封装的对应关系

| sales-admin (axios) | Flutter (dio) |
|---------------------|---------------|
| Http.get() | HttpRequest.get() |
| Http.post() | HttpRequest.post() |
| Http.put() | HttpRequest.put() |
| Http.delete() | HttpRequest.delete() |
| AxiosRequest.init() | HttpRequest.init() |
| setResponseInterceptors() | addRequestInterceptor() / addResponseInterceptor() |
| IAxiosResponse | HttpResponse |
| RequestConfig | Options (dio) |

## 注意事项

1. **只需初始化一次**：在 `main.dart` 中调用 `HttpRequest.init()` 一次即可
2. **拦截器自动生效**：在 `init()` 中设置的拦截器对所有请求自动生效，无需每次添加
3. **拦截器参数可选**：`onRequest`、`onResponse`、`onError` 都是可选参数
4. 对于需要类型转换的响应，使用 `fromJsonT` 参数
5. 文件上传下载等特殊场景可以直接使用 `HttpRequest.dio` 获取 Dio 实例
6. 建议将 API 调用封装到独立的 API 类中，便于管理和维护
