# 日志工具

## 概述

项目提供 `SystemLog` 工具类用于彩色日志输出，支持不同日志级别和 JSON 格式化。

## 文件位置

```
lib/utils/log.dart
```

## 日志级别

### success - 成功日志

```dart
SystemLog.success('操作成功');
```

显示：✅ SUCCESS: 操作成功（绿色）

### error - 错误日志

```dart
SystemLog.error('操作失败');
```

显示：❌ ERROR: 操作失败（红色）

### info - 信息日志

```dart
SystemLog.info('用户信息已加载');
```

显示：ℹ️ INFO: 用户信息已加载（蓝色）

### warning - 警告日志

```dart
SystemLog.warning('网络连接不稳定');
```

显示：⚠️ WARNING: 网络连接不稳定（黄色）

## JSON 日志

### 基本用法

```dart
final data = {
  'name': 'John',
  'age': 30,
  'email': 'john@example.com',
};

SystemLog.json(data);
```

### 带标签的 JSON 日志

```dart
SystemLog.json(data, label: '用户信息');
```

显示：
```
📦 JSON: 用户信息
{
  "name": "John",
  "age": 30,
  "email": "john@example.com"
}
```

### 非格式化 JSON

```dart
SystemLog.json(data, pretty: false);
```

输出单行 JSON 字符串。

## 使用场景

### HTTP 请求日志

```dart
// 请求日志
SystemLog.info('发起请求: GET /api/users');

// 响应日志
SystemLog.json(response.data, label: 'API 响应');

// 错误日志
SystemLog.error('请求失败: ${error.message}');
```

### 状态变化日志

```dart
void increment() {
  counter.value++;
  SystemLog.success('计数器增加: ${counter.value}');
}
```

### 调试日志

```dart
SystemLog.info('当前环境: ${Env.envName}');
SystemLog.info('API Host: ${Env.hostUrl}');
```

## 平台差异

### Android

使用 ANSI 颜色代码显示彩色日志：
- 绿色：成功
- 红色：错误
- 蓝色：信息
- 黄色：警告
- 青色：JSON

### iOS

iOS 不支持 ANSI 颜色代码，使用标签显示：
```
✅ SUCCESS: 操作成功
❌ ERROR: 操作失败
ℹ️ INFO: 用户信息已加载
⚠️ WARNING: 网络连接不稳定
📦 JSON: 用户信息
```

## 特性

### 自动分段

长文本（超过 800 字符）自动分段打印，避免被截断：

```dart
SystemLog.json(largeData);  // 自动分段打印
```

### 仅调试模式

所有日志仅在调试模式（`kDebugMode`）下输出，发布版本不会打印日志。

## 最佳实践

1. **使用合适的日志级别**：
   - `success` - 操作成功
   - `error` - 错误和异常
   - `info` - 一般信息
   - `warning` - 警告和注意事项

2. **避免敏感信息**：不要在日志中输出密码、token 等敏感信息

3. **使用 JSON 日志**：对于复杂数据结构使用 `SystemLog.json()`

4. **添加上下文**：在日志中包含足够的上下文信息

```dart
// 不好
SystemLog.error('失败');

// 好
SystemLog.error('用户登录失败: ${error.message}');
```

5. **在 HTTP 拦截器中使用**：

```dart
HttpRequest.addResponseInterceptor(
  onResponse: (response) {
    SystemLog.json(response.data, label: 'API 响应');
    return response;
  },
  onError: (error) {
    SystemLog.error('请求错误: ${error.message}');
    throw error;
  },
);
```

## 注意事项

1. 日志仅在调试模式下输出
2. iOS 平台不显示颜色，使用 emoji 标签区分
3. 长文本自动分段，避免被截断
4. JSON 解析失败时会输出错误日志
5. 不要在生产环境依赖日志输出
