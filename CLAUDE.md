# CLAUDE.md

本文件为 Claude Code（claude.ai/code）在此仓库中处理代码时提供指导。

## 环境要求

- Dart SDK：`^3.10.4`
- Flutter SDK：最新稳定版本
- Node.js：用于运行 npm 脚本和 mock 服务器
- iOS 开发需要安装 CocoaPods：`brew install cocoapods`

## 主要依赖

- `flutter_svg: ^2.0.0` - SVG 渲染支持
- `dio: ^5.7.0` - HTTP 请求库
- `signals: ^6.3.0` - 响应式状态管理
- `colorful_print: ^0.1.2` - 彩色日志输出
- `tdesign_flutter: ^0.2.6` - 腾讯 TDesign UI 组件库（详见 `.claude/rules/13-tdesign.md`）

## 构建和开发命令

### NPM 脚本（推荐）

```bash
# 安装依赖
pnpm i

# 开发环境运行（使用 .env.development）
npm run dev

# 生产环境运行（使用 .env.production）
npm run dev:prod

# Mock 环境运行（使用 .env.mock.local）
npm run dev:mock

# 构建 APK（生产环境）
npm run build:apk

# 构建 iOS（生产环境）
npm run build:ios

# 启动 mock 服务器
npm run server
```

### Flutter 命令

```bash
# 安装依赖
flutter pub get

# 使用环境配置运行
flutter run --dart-define-from-file .env.development
flutter run --dart-define-from-file .env.production

# 构建发布版本
flutter build apk --dart-define-from-file .env.production --release
flutter build ios --dart-define-from-file .env.production --release

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
- `lib/config/` - 配置文件（环境变量、常量配置）
- `lib/routes/` - 路由定义（`AppRoutes` 类）
- `lib/pages/home/` - 底部导航标签屏幕（HomeScreen、MessageScreen、MineScreen）
- `lib/pages/` - 通过命名路由访问的嵌套页面（DetailPage、EditPasswordPage）
- `lib/widgets/` - 可复用组件（`BottomNav`、`SvgIcon`、`ImageUploader`）
- `lib/api/` - API 接口定义和 HTTP 请求封装
  - `lib/api/request/` - HTTP 请求核心封装
  - `lib/api/common/` - 公共 API（图片上传等）
  - `lib/api/home/` - 首页相关 API
- `lib/stores/` - 状态管理（使用 signals）
- `lib/types/` - 类型定义（请求参数、响应数据、枚举等）
- `lib/utils/` - 工具函数（日志、尺寸适配、通用工具）
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

## 环境配置

项目支持多环境配置，通过 `.env` 文件和编译时环境变量实现：

- `.env.development` - 开发环境配置
- `.env.production` - 生产环境配置
- `.env.mock.local` - Mock 环境配置（自动生成）

在 `lib/config/env.dart` 中访问环境变量：

```dart
import 'package:ybx_parent_client/config/index.dart';

final apiHost = Env.hostUrl;      // API Host
final envName = Env.envName;      // 环境名称
final timeout = Env.timeout;      // 超时时间
```

## HTTP 请求

项目使用基于 `dio` 的 HTTP 请求封装（`lib/api/request/`）。

### 初始化

在 `main.dart` 中初始化（只需一次）：

```dart
import 'package:ybx_parent_client/api/request/index.dart';

void main() {
  HttpRequest.init();
  runApp(const MyApp());
}
```

### API 定义模式

在 `lib/api/` 下创建独立的 API 函数：

```dart
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

    return CompanionListResponse.fromJson(response.data ?? {});
  } catch (e) {
    rethrow;
  }
}
```

### 在组件中使用

```dart
Future<void> fetchData() async {
  try {
    final result = await queryNearbyCompanions(
      QueryNearbyCompanionsParam(page: 1, size: 10),
    );
    // 使用 result.list
  } catch (e) {
    SystemLog.error(e.toString());
  }
}
```

## 状态管理

项目使用 `signals` 进行响应式状态管理（`lib/stores/`）。

### Store 模式

```dart
class CounterStore {
  CounterStore._();
  static final CounterStore _instance = CounterStore._();
  static CounterStore get instance => _instance;

  final counter = signal(0);

  late final fullName = computed(
    () => 'counter: ${counter.value}',
  );

  void increment() => counter.value++;
}

final counterStore = CounterStore.instance;
```

### 在组件中使用

```dart
import 'package:signals/signals_flutter.dart';
import 'package:ybx_parent_client/stores/index.dart';

Watch((context) {
  return Text('Count: ${counterStore.counter.value}');
})

// 更新状态
ElevatedButton(
  onPressed: () => counterStore.increment(),
  child: Text('Increment'),
)
```

## 类型定义

所有类型定义放在 `lib/types/` 目录下。

### 数据模型

```dart
class CompanionListItem {
  CompanionListItem({
    required this.id,
    required this.userId,
    this.nickname,
  });

  final String id;
  final String userId;
  final String? nickname;

  factory CompanionListItem.fromJson(Map<String, dynamic> json) {
    return CompanionListItem(
      id: json['id'] as String,
      userId: json['userId'] as String,
      nickname: json['nickname'] as String?,
    );
  }
}
```

### 请求参数

```dart
class QueryNearbyCompanionsParam {
  QueryNearbyCompanionsParam({
    required this.page,
    required this.size,
  });

  final int page;
  final int size;

  Map<String, dynamic> toJson() {
    return {'page': page, 'size': size};
  }
}
```

## 日志工具

使用 `SystemLog` 进行彩色日志输出（`lib/utils/log.dart`）：

```dart
SystemLog.success('操作成功');
SystemLog.error('操作失败');
SystemLog.info('用户信息已加载');
SystemLog.warning('网络连接不稳定');
SystemLog.json(data, label: '用户信息');
```

日志仅在调试模式下输出，发布版本不会打印。

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
