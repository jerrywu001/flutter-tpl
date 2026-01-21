# TDesign 组件库

## 概述

TDesign Flutter 是腾讯开源的 UI 组件库，采用 TDesign 设计风格，提供完整的移动端组件解决方案。

## 版本要求

- `tdesign_flutter: ^0.2.6`
- Dart: `>=2.19.0 <4.0.0`
- Flutter: `>=3.7.0`

## 基本使用

### 引入组件

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

### 主题使用

TDesign 提供了完整的主题系统，支持颜色、字体、圆角、阴影等自定义。

```dart
// 获取当前上下文主题
final brandColor = TDTheme.of(context).brandNormalColor;
final bodyFont = TDTheme.of(context).fontBodyLarge;

// 获取默认主题
final defaultTheme = TDTheme.defaultData();
```

### 图标使用

TDesign 内置了完整的图标库：

```dart
Icon(TDIcons.activity)
Icon(TDIcons.add)
Icon(TDIcons.close)
Icon(TDIcons.check)
```

## 常用组件

### 基础组件

**按钮 (TDButton)**
```dart
TDButton(
  text: '主要按钮',
  type: TDButtonType.fill,
  theme: TDButtonTheme.primary,
  onTap: () {},
)

TDButton(
  text: '次要按钮',
  type: TDButtonType.outline,
  onTap: () {},
)
```

**文本 (TDText)**
```dart
TDText(
  '标题文本',
  font: TDTheme.of(context).fontTitleLarge,
  textColor: TDTheme.of(context).fontGyColor1,
)
```

### 表单组件

**输入框 (TDInput)**
```dart
TDInput(
  controller: _controller,
  hintText: '请输入内容',
  onChanged: (value) {},
)
```

**单选框 (TDRadio)**
```dart
TDRadio(
  id: '1',
  title: '选项1',
  radioStyle: TDRadioStyle.circle,
  enable: true,
)
```

**复选框 (TDCheckbox)**
```dart
TDCheckbox(
  id: '1',
  title: '选项1',
  enable: true,
)
```

**开关 (TDSwitch)**
```dart
TDSwitch(
  isOn: true,
  onChanged: (value) {},
)
```

### 反馈组件

**对话框 (TDDialog)**
```dart
TDDialog.show(
  context: context,
  title: '提示',
  content: '确认删除吗？',
  leftBtn: '取消',
  rightBtn: '确认',
  onConfirm: () {},
)
```

**Toast (TDToast)**
```dart
TDToast.showText('操作成功', context: context);
TDToast.showSuccess('保存成功', context: context);
TDToast.showWarning('请注意', context: context);
TDToast.showFail('操作失败', context: context);
TDToast.showLoading(context: context);
```

**加载中 (TDLoading)**
```dart
TDLoading(
  size: TDLoadingSize.large,
  icon: TDLoadingIcon.circle,
)
```

### 导航组件

**标签栏 (TDTabBar)**
```dart
TDTabBar(
  tabs: [
    TDTabBarItem(label: '首页'),
    TDTabBarItem(label: '消息'),
    TDTabBarItem(label: '我的'),
  ],
  currentIndex: 0,
  onChange: (index) {},
)
```

**导航栏 (TDNavBar)**
```dart
TDNavBar(
  title: '页面标题',
  leftBtn: TDNavBarItem(icon: TDIcons.chevron_left),
  onLeftBtnClick: () => Navigator.pop(context),
)
```

### 数据展示

**列表 (TDCell)**
```dart
TDCell(
  title: '标题',
  note: '说明文字',
  arrow: true,
  onClick: () {},
)
```

**标签 (TDTag)**
```dart
TDTag(
  '标签',
  theme: TDTagTheme.primary,
  size: TDTagSize.medium,
)
```

**徽章 (TDBadge)**
```dart
TDBadge(
  TDBadgeType.redPoint,
  child: Icon(TDIcons.notification),
)
```

## 主题配置

### 自定义主题

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      TDThemeData(
        brandNormalColor: Color(0xFF0052D9),
        brandFocusColor: Color(0xFF0034B5),
        // 更多主题配置...
      ),
    ],
  ),
)
```

### 通过 JSON 配置主题

TDesign 支持通过 JSON 文件配置主题样式，便于统一管理和切换主题。

## 最佳实践

### 1. 统一使用 TDesign 组件

在项目中优先使用 TDesign 组件，保持 UI 风格一致：

```dart
// 推荐
TDButton(text: '按钮', onTap: () {})

// 避免混用
ElevatedButton(onPressed: () {}, child: Text('按钮'))
```

### 2. 使用主题系统

通过主题系统获取颜色和字体，而不是硬编码：

```dart
// 推荐
color: TDTheme.of(context).brandNormalColor

// 避免
color: Color(0xFF0052D9)
```

### 3. 响应式尺寸

结合项目的 rpx 单位使用 TDesign 组件：

```dart
TDButton(
  text: '按钮',
  size: TDButtonSize.large,
  width: 300.rpx,
)
```

### 4. 统一反馈提示

使用 TDToast 和 TDDialog 提供统一的用户反馈：

```dart
// 成功提示
TDToast.showSuccess('操作成功', context: context);

// 确认对话框
TDDialog.show(
  context: context,
  title: '提示',
  content: '确认删除吗？',
  onConfirm: () {},
)
```

### 5. 图标使用

优先使用 TDIcons 内置图标，保持图标风格统一：

```dart
Icon(TDIcons.home)
Icon(TDIcons.user)
Icon(TDIcons.setting)
```

## 注意事项

1. TDesign 组件依赖 `easy_refresh`、`flutter_slidable` 等第三方库
2. 部分组件可能需要在 `MaterialApp` 或 `Scaffold` 上下文中使用
3. 使用 TDToast 和 TDDialog 时需要传入 `context`
4. 主题配置需要在 `MaterialApp` 的 `theme` 中设置
5. 图标库需要通过 `TDIcons` 类访问

## 迁移指南

### 从自定义工具函数迁移到 TDesign

项目已移除 `showToast` 和 `showConfirm` 工具函数，统一使用 TDesign 组件：

**Toast 提示**
```dart
// 旧方式（已移除）
// showToast('操作成功');

// 新方式
TDToast.showText('操作成功', context: context);
TDToast.showSuccess('保存成功', context: context);
TDToast.showFail('操作失败', context: context);
```

**确认对话框**
```dart
// 旧方式（已移除）
// showConfirm(
//   context: context,
//   title: '提示',
//   content: '确认删除吗？',
//   onConfirm: () {},
// );

// 新方式
TDDialog.show(
  context: context,
  title: '提示',
  content: '确认删除吗？',
  leftBtn: '取消',
  rightBtn: '确认',
  onConfirm: () {},
);
```

## 资源链接

- [官方文档](https://tdesign.tencent.com/flutter/getting-started)
- [GitHub 仓库](https://github.com/Tencent/tdesign-flutter)
- [pub.dev](https://pub.dev/packages/tdesign_flutter)
- [示例代码](https://github.com/Tencent/tdesign-flutter/tree/main/example)
