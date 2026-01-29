# 哀悼日模式

## 概述

项目支持哀悼日模式（灰度滤镜），在特殊日期（如国家公祭日、重大灾难纪念日）自动将整个应用界面变为灰色，以示哀悼。

## 功能特性

- ✅ 自动检测哀悼日期
- ✅ 服务器接口控制（灵活配置）
- ✅ 接口失败时降级到本地日期检查
- ✅ 应用启动和恢复时自动检查
- ✅ 全屏灰度滤镜效果
- ✅ Mock 环境支持手动测试

## 工作原理

### 1. 状态管理

哀悼日状态在 `main.dart` 的 `_MyAppState` 中管理：

```dart
class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  /// 是否是哀悼日
  bool _isMourningDay = false;

  /// 灰度滤镜矩阵
  static const ColorFilter _grayscaleFilter = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0, // 红色通道
    0.2126, 0.7152, 0.0722, 0, 0, // 绿色通道
    0.2126, 0.7152, 0.0722, 0, 0, // 蓝色通道
    0, 0, 0, 1, 0, // Alpha通道
  ]);
}
```

### 2. 查询时机

哀悼日状态在以下时机自动查询更新：

- **应用启动时**：`initState` → `SchedulerBinding.addPostFrameCallback`
- **从后台返回前台时**：`didChangeAppLifecycleState` → `AppLifecycleState.resumed`

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addObserver(this);
  SchedulerBinding.instance.addPostFrameCallback((_) {
    _fetchMourningStatus();
  });
}

@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.resumed) {
    _fetchMourningStatus();
  }
}
```

### 3. 灰度滤镜应用

在 `MaterialApp` 的 `builder` 中应用灰度滤镜：

```dart
builder: (context, child) {
  SizeFit.initialize(context);
  final sizedChild = child ?? const SizedBox.shrink();

  if (_isMourningDay) {
    return ColorFiltered(
      colorFilter: _grayscaleFilter,
      child: sizedChild,
    );
  }

  return sizedChild;
}
```

## API 接口

### 查询哀悼日状态

```dart
Future<MourningStatusResponse> queryMourningStatus() async {
  final response = await HttpRequest.get<Map<String, dynamic>>(
    '/api/mourning/status',
  );

  if (!response.isSuccess || response.code != HttpResponseCode.succeed.code) {
    throw response.message ?? '查询哀悼日状态失败';
  }

  return MourningStatusResponse.fromJson(response.data ?? {});
}
```

### 响应类型

```dart
class MourningStatusResponse {
  final bool isMourningDay;
  final String? reason;
  final String? startDate;
  final String? endDate;
}
```

## 错误处理

当接口调用失败时，自动降级到本地日期检查：

```dart
Future<void> _fetchMourningStatus() async {
  try {
    final result = await queryMourningStatus();
    // 更新状态...
  } catch (e) {
    // 接口失败时使用本地日期检查
    SystemLog.error('查询哀悼日状态失败: $e');
    _checkMourningDayLocally();
  }
}
```

## 支持的哀悼日期（本地降级）

- **12月13日** - 南京大屠杀死难者国家公祭日
- **5月12日** - 汶川地震纪念日
- **4月4日** - 清明节
- **7月28日** - 唐山大地震纪念日

## Mock 环境测试

在 mock 环境下，可以通过首页的测试按钮手动切换哀悼模式：

### 测试按钮位置

首页 → 滚动到底部 → "哀悼模式测试（仅开发环境）"

### 测试按钮功能

- **开启** - 启用哀悼模式
- **关闭** - 禁用哀悼模式
- **自动** - 恢复自动判断模式

### 查看效果

点击测试按钮后，**切换到后台再返回**即可查看灰度效果。

## 最佳实践

### 1. 服务器控制为主

- 优先使用服务器接口控制哀悼日状态
- 服务器可以动态开启/关闭哀悼模式
- 服务器可以自定义哀悼原因和日期范围

### 2. 本地降级为辅

- 接口失败时自动降级到本地日期检查
- 确保即使网络问题也能正常工作
- 本地日期列表与服务器保持同步

### 3. 无感知切换

- 哀悼模式自动生效，无需用户操作
- 状态变化时输出日志便于调试
- 灰度滤镜影响整个应用，包括所有页面

## 注意事项

1. **仅在 main.dart 中管理状态** - 不使用 Store 或全局状态管理
2. **避免频繁查询** - 只在应用启动和恢复时查询
3. **测试环境专用** - 测试按钮仅在 mock/开发环境显示
4. **生产环境静默** - 接口失败时不显示错误提示，仅记录日志

## 相关文件

- `lib/main.dart` - 哀悼日模式实现和状态管理
- `lib/api/mourning/index.dart` - 哀悼日 API 接口
- `lib/types/mourning/index.dart` - 哀悼日类型定义
- `mocks/controllers/mourning.controller.cjs` - Mock 接口实现

## 参考资源

- [ColorFiltered 类文档](https://api.flutter.dev/flutter/widgets/ColorFiltered-class.html)
- [ColorFilter.matrix 矩阵说明](https://api.flutter.dev/flutter/dart-ui/ColorFilter/ColorFilter.matrix.html)
- [WidgetsBindingObserver 生命周期](https://api.flutter.dev/flutter/widgets/WidgetsBindingObserver-mixin.html)
