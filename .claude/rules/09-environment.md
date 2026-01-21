# 环境配置

## 概述

项目支持多环境配置，通过 `.env` 文件和编译时环境变量实现不同环境的切换。

## 环境文件

项目包含两个环境配置文件：

- `.env.development` - 开发环境配置
- `.env.production` - 生产环境配置

### 配置示例

```bash
# .env.development
API_HOST = https://youbanxue-gateway-dev.upfreework.cn
ENV_NAME = development
```

```bash
# .env.production
API_HOST = https://youbanxue-gateway.upfreework.cn
ENV_NAME = production
```

## Env 配置类

`lib/config/env.dart` 提供统一的环境配置访问：

```dart
class Env {
  /// API 请求超时时间
  static const Duration timeout = Duration(seconds: 30);

  /// API Host URL (通过编译时环境变量注入)
  static const String hostUrl = String.fromEnvironment('API_HOST');

  /// 环境名称 (通过编译时环境变量注入)
  static const String envName = String.fromEnvironment('ENV_NAME');

  /// 是否打印错误日志
  static const bool printError = true;
}
```

## 使用方式

### 通过 NPM 脚本运行（推荐）

```bash
# 开发环境
npm run dev

# 生产环境
npm run dev:prod
```

### 通过 Flutter 命令运行

```bash
# 开发环境
flutter run --dart-define-from-file .env.development

# 生产环境
flutter run --dart-define-from-file .env.production
```

### 构建发布版本

```bash
# 构建 APK（生产环境）
npm run build:apk
# 或
flutter build apk --dart-define-from-file .env.production --release

# 构建 iOS（生产环境）
npm run build:ios
# 或
flutter build ios --dart-define-from-file .env.production --release
```

## 在代码中使用

```dart
import 'package:ybx_parent_client/config/env.dart';

// 获取 API Host
final apiHost = Env.hostUrl;

// 获取环境名称
final envName = Env.envName;

// 获取超时时间
final timeout = Env.timeout;
```

## HTTP 请求集成

环境配置已集成到 HTTP 请求系统中：

```dart
// lib/api/request/http_request.dart
static void init() {
  _dio = Dio(
    BaseOptions(
      baseUrl: Env.hostUrl,  // 使用环境配置的 API Host
      connectTimeout: Env.timeout,
      receiveTimeout: Env.timeout,
      sendTimeout: Env.timeout,
    ),
  );
}
```

## 注意事项

1. 环境变量在编译时注入，运行时不可修改
2. 切换环境需要重新编译应用
3. `.env` 文件不应包含敏感信息（如密钥），应使用 `.gitignore` 排除
4. 推荐使用 npm 脚本运行，简化命令行操作
