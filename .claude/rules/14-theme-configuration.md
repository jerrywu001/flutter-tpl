# 主题配置功能

## 概述

项目已集成 TDesign Flutter 的深色模式支持，提供浅色、深色和跟随系统三种主题模式。

## 功能特性

- ✅ 浅色模式
- ✅ 深色模式
- ✅ 跟随系统
- ✅ 主题持久化（使用 SharedPreferences）
- ✅ 响应式状态管理（使用 signals）

## 使用方式

### 1. 在代码中切换主题

```dart
import 'package:ybx_parent_client/stores/index.dart';

// 切换到浅色模式
await themeStore.setLightMode();

// 切换到深色模式
await themeStore.setDarkMode();

// 跟随系统
await themeStore.setSystemMode();

// 或直接设置主题模式
await themeStore.setThemeMode(AppThemeMode.dark);
```

### 2. 读取当前主题模式

```dart
// 获取当前主题模式
final currentMode = themeStore.themeMode.value;

// 在 Widget 中响应主题变化
Watch((context) {
  final isDark = themeStore.themeMode.value == AppThemeMode.dark;
  return Text(isDark ? '深色模式' : '浅色模式');
})
```

### 3. 导航到主题设置页面

```dart
Navigator.pushNamed(context, AppRoutes.themeSettings);
```

## 实现原理

### 1. 主题状态管理

使用 `signals` 进行响应式状态管理：

```dart
// lib/stores/theme/theme_store.dart
class ThemeStore {
  /// GetStorage 实例
  final _storage = GetStorage();

  /// 当前主题模式
  final themeMode = signal<AppThemeMode>(AppThemeMode.system);

  /// 获取 Flutter ThemeMode（计算属性）
  late final flutterThemeMode = computed(() {
    switch (themeMode.value) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  });
}
```

### 2. TDesign 主题集成

在 `main.dart` 中配置 TDesign 主题：

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 GetStorage
  await GetStorage.init();

  // 启用 TDesign 多主题功能
  TDTheme.needMultiTheme(true);

  // 初始化主题状态
  await themeStore.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeData = TDTheme.defaultData();

    return Watch((context) {
      return MaterialApp(
        theme: themeData.systemThemeDataLight,
        darkTheme: themeData.systemThemeDataDark,
        themeMode: themeStore.flutterThemeMode.value,
        // ...
      );
    });
  }
}
```

### 3. 主题持久化

使用 `get_storage` 持久化主题设置（纯 Dart 实现，无需原生代码）：

```dart
Future<void> setThemeMode(AppThemeMode mode) async {
  themeMode.value = mode;
  await _storage.write('theme_mode', mode.value);
}

Future<void> init() async {
  final savedTheme = _storage.read<String>('theme_mode');
  if (savedTheme != null) {
    themeMode.value = AppThemeMode.fromValue(savedTheme);
  }
}
```

## 主题设置页面

项目提供了一个完整的主题设置页面 `ThemeSettingsPage`，包含：

- 跟随系统开关
- 浅色/深色模式选择
- 当前选中状态指示

## 自定义主题

如果需要自定义主题颜色，可以通过 JSON 配置文件实现：

### 1. 创建主题配置文件

在 `assets/` 目录下创建 `theme.json`：

```json
{
  "default": {
    "ref": {
      "brandNormalColor": "brandColor7"
    },
    "color": {
      "brandColor7": "#0052D9"
    }
  },
  "defaultDark": {
    "ref": {
      "brandNormalColor": "brandColor8"
    },
    "color": {
      "brandColor8": "#4582e6"
    }
  }
}
```

### 2. 在 pubspec.yaml 中添加资源

```yaml
flutter:
  assets:
    - assets/theme.json
```

### 3. 加载自定义主题

在 `main.dart` 中加载主题配置：

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 加载主题配置
  final themeJsonString = await rootBundle.loadString('assets/theme.json');

  // 启用多主题
  TDTheme.needMultiTheme(true);

  // 从 JSON 加载主题
  final themeData = TDThemeData.fromJson(
    'default',
    themeJsonString,
    darkName: 'defaultDark',
  ) ?? TDTheme.defaultData();

  // 初始化主题状态
  await themeStore.init();

  runApp(MyApp(themeData: themeData));
}
```

## 注意事项

1. **初始化顺序**：必须在 `runApp()` 之前调用 `GetStorage.init()` 和 `themeStore.init()` 加载保存的主题设置
2. **Watch 包裹**：MaterialApp 需要用 `Watch` 包裹以响应主题变化
3. **TDesign 版本**：需要 `tdesign_flutter: ^0.2.6` 或更高版本
4. **依赖要求**：使用 `get_storage` 替代 `shared_preferences`，避免原生代码编译问题

## 相关文件

- `lib/stores/theme/theme_store.dart` - 主题状态管理
- `lib/pages/settings/theme_settings_page.dart` - 主题设置页面
- `lib/main.dart` - 主题集成和初始化
- `lib/routes/routes.dart` - 路由配置

## 参考文档

- [TDesign Flutter 深色模式](https://tdesign.tencent.com/flutter/dark-mode)
- [TDesign Flutter 自定义主题](https://tdesign.tencent.com/flutter/getting-started#%E8%87%AA%E5%AE%9A%E4%B9%89%E4%B8%BB%E9%A2%98)
- [signals 状态管理](https://pub.dev/packages/signals)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
