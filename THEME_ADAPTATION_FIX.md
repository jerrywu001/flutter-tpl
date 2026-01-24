# 主题适配修复说明

## 问题描述

底部导航栏（BottomNav）和"我的"页面（MineScreen）在切换主题时没有响应变化，仍然显示固定的颜色。

## 根本原因

这两个组件使用了硬编码的颜色值，而不是从 TDesign 主题系统获取颜色：

### BottomNav 问题
```dart
// ❌ 硬编码颜色
backgroundColor: Colors.white,
selectedItemColor: const Color(0xFFA28071),
```

### MineScreen 问题
```dart
// ❌ 硬编码颜色
color: const Color(0xFF333333),
color: Colors.white,
color: Colors.grey.shade400,
```

## 解决方案

### 1. BottomNav 修复

**修改前：**
```dart
return BottomNavigationBar(
  backgroundColor: Colors.white,
  selectedItemColor: const Color(0xFFA28071),
  unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
  // ...
);
```

**修改后：**
```dart
final theme = TDTheme.of(context);

return BottomNavigationBar(
  backgroundColor: theme.bgColorContainer,
  selectedItemColor: theme.brandNormalColor,
  unselectedItemColor: theme.fontGyColor3,
  // ...
);
```

**使用的主题颜色：**
- `bgColorContainer` - 容器背景色（浅色模式白色，深色模式深灰）
- `brandNormalColor` - 品牌主色（选中项颜色）
- `fontGyColor3` - 三级文字颜色（未选中项颜色）

### 2. MineScreen 修复

#### 状态栏适配
```dart
final isDark = Theme.of(context).brightness == Brightness.dark;

final overlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
  statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
);
```

#### 背景图片适配
```dart
Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: const AssetImage('assets/home/mine-bg.png'),
      fit: BoxFit.fitWidth,
      alignment: Alignment.topCenter,
      opacity: isDark ? 0.3 : 1.0,  // 深色模式降低透明度
    ),
  ),
)
```

#### 文字颜色适配
```dart
final theme = TDTheme.of(context);

Text(
  '上海吉舰嘉科技服务有限公司',
  style: TextStyle(
    color: theme.fontGyColor1,  // 使用主题颜色
    fontSize: 36.rpx,
    fontWeight: FontWeight.w600,
  ),
)
```

#### 卡片背景适配
```dart
Material(
  color: theme.bgColorContainer,  // 使用主题背景色
  borderRadius: BorderRadius.circular(12.rpx),
  // ...
)
```

#### 菜单项颜色适配
```dart
Widget menuItem({...}) {
  final theme = TDTheme.of(context);

  return InkWell(
    splashColor: theme.fontGyColor4.withValues(alpha: 0.1),
    child: Row(
      children: [
        SvgIcon(icon: icon, color: theme.fontGyColor1),
        Text(title, style: TextStyle(color: theme.fontGyColor1)),
        Icon(Icons.arrow_forward_ios, color: theme.fontGyColor3),
      ],
    ),
  );
}
```

## TDesign 主题颜色说明

### 背景颜色
- `bgColorPage` - 页面背景色
- `bgColorContainer` - 容器背景色
- `bgColorSecondaryContainer` - 次级容器背景色
- `bgColorComponent` - 组件背景色

### 文字颜色
- `fontGyColor1` - 一级文字（主要内容）
- `fontGyColor2` - 二级文字（次要内容）
- `fontGyColor3` - 三级文字（辅助信息）
- `fontGyColor4` - 四级文字（禁用状态）

### 品牌颜色
- `brandNormalColor` - 品牌主色
- `brandFocusColor` - 品牌聚焦色
- `brandActiveColor` - 品牌激活色
- `brandDisabledColor` - 品牌禁用色

### 边框颜色
- `componentStrokeColor` - 组件描边色
- `componentBorderColor` - 组件边框色

## 验证方法

### 1. 底部导航栏测试
1. 切换到浅色模式
   - ✅ 背景应该是白色
   - ✅ 选中项应该是蓝色
   - ✅ 未选中项应该是灰色

2. 切换到深色模式
   - ✅ 背景应该是深灰色
   - ✅ 选中项应该是浅蓝色
   - ✅ 未选中项应该是浅灰色

### 2. "我的"页面测试
1. 切换到浅色模式
   - ✅ 文字应该是深色
   - ✅ 卡片背景应该是白色
   - ✅ 图标应该是深色
   - ✅ 背景图片正常显示

2. 切换到深色模式
   - ✅ 文字应该是浅色
   - ✅ 卡片背景应该是深灰色
   - ✅ 图标应该是浅色
   - ✅ 背景图片半透明显示

### 3. 状态栏测试
1. 浅色模式
   - ✅ 状态栏图标应该是深色

2. 深色模式
   - ✅ 状态栏图标应该是浅色

## 最佳实践

### ✅ 推荐做法
```dart
// 使用 TDesign 主题颜色
final theme = TDTheme.of(context);
color: theme.fontGyColor1

// 使用 Theme 判断深色模式
final isDark = Theme.of(context).brightness == Brightness.dark;
```

### ❌ 避免做法
```dart
// 不要硬编码颜色
color: const Color(0xFF333333)
color: Colors.white
color: Colors.grey.shade400

// 不要使用固定的状态栏样式
statusBarIconBrightness: Brightness.dark  // 应该根据主题动态设置
```

## 其他需要适配的组件

如果发现其他页面或组件在切换主题时没有响应，检查是否使用了硬编码颜色，并按照以下步骤修复：

1. **获取主题对象**
   ```dart
   final theme = TDTheme.of(context);
   ```

2. **替换硬编码颜色**
   - 文字颜色 → `theme.fontGyColor1/2/3/4`
   - 背景颜色 → `theme.bgColorContainer/Page/Component`
   - 品牌颜色 → `theme.brandNormalColor`
   - 边框颜色 → `theme.componentBorderColor`

3. **适配状态栏**
   ```dart
   final isDark = Theme.of(context).brightness == Brightness.dark;
   statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark
   ```

4. **测试验证**
   - 切换到浅色模式测试
   - 切换到深色模式测试
   - 检查所有 UI 元素是否正确显示

## 相关文件

- `lib/widgets/bottom_nav.dart` - 底部导航栏（已修复）
- `lib/pages/home/mine_screen.dart` - 我的页面（已修复）
- `.claude/rules/14-theme-configuration.md` - 主题配置文档

## 总结

通过将硬编码的颜色值替换为 TDesign 主题系统提供的动态颜色，现在底部导航栏和"我的"页面都能正确响应主题切换了。

所有使用 TDesign 主题颜色的组件都会自动适配浅色和深色模式，无需额外处理。
