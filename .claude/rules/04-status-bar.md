# 状态栏样式管理

## 基本方法

使用 `AnnotatedRegion<SystemUiOverlayStyle>` 管理特定页面的状态栏外观：

```dart
return AnnotatedRegion<SystemUiOverlayStyle>(
  value: const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,  // Brightness.light 用于浅色图标
  ),
  child: Scaffold(...),
);
```

## 动态状态栏样式

对于具有动态状态栏样式的页面（如带滚动的 DetailPage），改为更新 AppBar 的 `systemOverlayStyle` 属性：

```dart
appBar: AppBar(
  systemOverlayStyle: SystemUiOverlayStyle(
    statusBarIconBrightness: _calculateBrightness(),
  ),
),
```
