import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:ybx_parent_client/api/mourning/index.dart';
import 'package:ybx_parent_client/api/request/index.dart';
import 'package:ybx_parent_client/routes/routes.dart';
import 'package:ybx_parent_client/stores/index.dart';
import 'package:ybx_parent_client/utils/index.dart';

import 'pages/home/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 GetStorage
  await GetStorage.init();

  // 初始化 HTTP 请求
  HttpRequest.init();

  // 启用 TDesign 多主题功能
  TDTheme.needMultiTheme(true);

  // 初始化主题状态
  await themeStore.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

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

  @override
  void initState() {
    super.initState();
    // 注册应用生命周期观察者
    WidgetsBinding.instance.addObserver(this);
    // 应用启动后第一帧时查询哀悼日状态
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _fetchMourningStatus();
    });
  }

  @override
  void dispose() {
    // 移除观察者
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 当应用从后台返回前台时，重新检查哀悼日
    if (state == AppLifecycleState.resumed) {
      _fetchMourningStatus();
    }
  }

  /// 查询哀悼日状态
  Future<void> _fetchMourningStatus() async {
    try {
      final result = await queryMourningStatus();

      if (result.isMourningDay != _isMourningDay) {
        setState(() {
          _isMourningDay = result.isMourningDay;
        });

        if (result.isMourningDay) {
          SystemLog.warning('🕯️ 哀悼模式已开启');
        }
      }
    } catch (e) {
      SystemLog.error('查询哀悼日状态失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 获取 TDesign 默认主题数据
    final themeData = TDTheme.defaultData();

    return Watch((context) {
      // 别删除，Fix安卓: signal 依赖被追踪（直接访问 themeMode）
      final _ = themeStore.themeMode.value;

      SystemLog.success(
        '🌗 System Theme Changed:  ${themeStore.flutterThemeMode.value}（${themeStore.themeMode.value}）',
      );

      return MaterialApp(
        title: 'Flutter Demo',
        // 浅色主题
        theme: themeData.systemThemeDataLight,
        // 深色主题
        darkTheme: themeData.systemThemeDataDark,
        // 主题模式（响应式）
        themeMode: themeStore.flutterThemeMode.value,
        initialRoute: AppRoutes.home,
        builder: (context, child) {
          // rpx适配
          SizeFit.initialize(context);
          final sizedChild = child ?? const SizedBox.shrink();

          // 哀悼日模式下应用灰度滤镜
          if (_isMourningDay) {
            return ColorFiltered(
              colorFilter: _grayscaleFilter,
              child: sizedChild,
            );
          }

          return sizedChild;
        },
        routes: {
          AppRoutes.home: (context) =>
              const MyHomePage(title: 'Flutter Demo Home Page'),
          ...AppRoutes.routes,
        },
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MessageScreen(),
    const MineScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _screens[_selectedIndex];
  }
}
