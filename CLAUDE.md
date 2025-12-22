# CLAUDE.md

本文件为 Claude Code（claude.ai/code）在此仓库中处理代码时提供指导。

## 环境要求

- Dart SDK：`^3.10.4`
- Flutter SDK：最新稳定版本

## 主要依赖

- `flutter_svg: ^2.0.0` - SVG 渲染支持

## 构建和开发命令

```bash
# 安装依赖
flutter pub get

# 运行应用（调试模式）
flutter run

# 在特定设备上运行应用
flutter run -d <device_id>

# 构建发布版本
flutter build apk          # Android
flutter build ios          # iOS
flutter build windows      # Windows

# 代码分析
flutter analyze

# 运行测试
flutter test

# 运行单个测试文件
flutter test test/widget_test.dart

# 格式化代码
dart format .
```

## 应用架构

这是一个采用底部导航标签栏布局的 Flutter 应用。

### 整体结构

应用以 `MyHomePage`（位于 `main.dart`）作为根容器，管理标签页状态并在不同屏幕小部件之间切换。每个屏幕都是完整的 `Scaffold`，拥有自己的 `AppBar`、主体内容和 `BottomNavigationBar`。

### 项目结构

- `lib/main.dart` - 应用入口；包含 `MyApp`、`MyHomePage` 和 `MyHomePageState`（管理标签页切换）
- `lib/config/routes.dart` - 集中式路由定义（`AppRoutes` 类）
- `lib/pages/home/` - 底部导航标签屏幕（HomeScreen、MessageScreen、MineScreen）
- `lib/pages/` - 通过命名路由访问的嵌套页面（DetailPage、EditPasswordPage）
- `lib/widgets/` - 可复用组件（`BottomNav`、`SvgIcon`）
- `lib/utils/tools.dart` - 共享工具函数（`showConfirm`、`showToast`、`formatDate`、`isValidEmail`、`debounce`）
- `lib/utils/size_fit.dart` - 响应式设计系统工具
- `assets/` - 静态资源（在 `pubspec.yaml` 中引用）

### 标签页导航模式

主应用使用由 `MyHomePageState` 管理的标签页布局：
- `_selectedIndex` 跟踪当前活跃标签页（0=首页，1=消息，2=我的）
- `_screens` 列表包含三个屏幕小部件
- `onItemTapped(int index)` 更新状态并触发重新构建选定的屏幕

每个屏幕小部件（HomeScreen、MessageScreen、MineScreen）导入 `BottomNav` 并传递自己的 `currentIndex`。`BottomNav` 小部件处理导航栏 UI 并通过 `context.findAncestorStateOfType<MyHomePageState>()` 调用 `MyHomePageState.onItemTapped()`。

### 状态栏样式管理

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

对于具有动态状态栏样式的页面（如带滚动的 DetailPage），改为更新 AppBar 的 `systemOverlayStyle` 属性：

```dart
appBar: AppBar(
  systemOverlayStyle: SystemUiOverlayStyle(
    statusBarIconBrightness: _calculateBrightness(),
  ),
),
```

### 响应式设计系统

项目使用 `SizeFit` 工具进行响应式尺寸调整，基于标准 750px 设计宽度。这在不同设备尺寸上按比例缩放所有尺寸。

**使用 rpx 单位：**
- `num` 上的 `rpx` 扩展允许直接进行响应式尺寸调整
- `20.rpx` 将设计尺寸转换为逻辑像素
- 示例：`width: 300.rpx` 或 `padding: EdgeInsets.all(10.rpx)`

**工作原理：**
- `SizeFit.rpx` = 屏幕宽度 / 750（缩放因子）
- `20.rpx` 等同于 `20 * SizeFit.rpx` 逻辑像素
- 通过 `MyApp.builder` 中的 `SizeFit.initialize(context)` 自动初始化

### 可复用组件

**SvgIcon** - 简化的 SVG 图标组件，呈现 1:1 纵横比的正方形图标：
```dart
SvgIcon(
  icon: 'assets/home/icon-user.svg',
  size: 20,
  color: Color(0xFF333333),  // 可选，默认为 Color(0xFFA28071)
)
```

### 命名路由导航模式

命名路由在 `AppRoutes` 中定义并在 `MaterialApp.routes` 中注册。使用以下方式导航：
```dart
Navigator.pushNamed(context, AppRoutes.dataList);
```

命名路由提供全屏导航，显示在标签页结构上方（如导航到详情页）。用命名路由离开标签页布局；用标签页索引切换在三个主屏幕之间切换。

## 代码风格

代码检查在 `analysis_options.yaml` 中配置，强制执行以下规则：
- `prefer_const_constructors` - 优先使用 const 构造函数
- `prefer_final_fields` - 对字段优先使用 final
- `prefer_final_locals` - 对局部变量优先使用 final
- `prefer_single_quotes` - 优先使用单引号
- `require_trailing_commas` - 要求尾部逗号

## Material 交互

使用 `Material` 小部件作为 `InkWell` 的父容器，以启用彩色背景上的正确墨水飞溅效果：

```dart
Material(
  color: Colors.white,
  borderRadius: BorderRadius.circular(6),
  child: InkWell(
    onTap: () { /* ... */ },
    splashColor: Colors.grey.withValues(alpha: 0.1),
    child: Padding(...),
  ),
)
```

没有 `Material` 作为父容器，`InkWell` 的墨水效果在不透明背景上将不可见。
