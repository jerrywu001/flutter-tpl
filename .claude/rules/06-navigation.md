# 导航模式

## 命名路由导航

命名路由在 `AppRoutes` 中定义并在 `MaterialApp.routes` 中注册。使用以下方式导航：

```dart
Navigator.pushNamed(context, AppRoutes.detail);
```

## 导航类型选择

- **命名路由**：用于离开标签页布局进行全屏导航（如导航到详情页）
- **标签页索引切换**：用于在三个主屏幕（首页、消息、我的）之间切换

## AppRoutes 定义

`AppRoutes` 类（位于 `lib/routes/routes.dart`）是所有路由定义的单一信息源：

```dart
class AppRoutes {
  static const String home = '/';
  static const String detail = '/detail';
  static const String editPassword = '/edit_password';

  static const String initialRoute = home;

  static Map<String, WidgetBuilder> routes = {
    detail: (context) => const DetailPage(),
    editPassword: (context) => const EditPassword(),
  };
}
```
